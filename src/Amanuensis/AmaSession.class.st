Class {
	#name : #AmaSession,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'clientStream',
		'serverStream'
	],
	#category : #Amanuensis
}

{ #category : #'private - accessing' }
AmaSession class >> clientStream [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
AmaSession class >> forClient: aSocket [

	^ self new clientSocket: aSocket
]

{ #category : #accessing }
AmaSession >> announcer: anAnnouncer [

	announcer := anAnnouncer
]

{ #category : #accessing }
AmaSession >> clientSocket: aSocket [

	clientStream := SocketStream on: aSocket
]

{ #category : #accessing }
AmaSession >> clientStream [
	^ clientStream
]

{ #category : #accessing }
AmaSession >> clientStream: aStream [

	clientStream := aStream
]

{ #category : #running }
AmaSession >> establishServerConnection: aHostName [

	serverStream := SocketStream openConnectionToHostNamed: aHostName port: 80 
]

{ #category : #running }
AmaSession >> readBody: message fromStream: aStream [

	| contentLength transferEncodings |
	contentLength := message contentLength.
	contentLength > 0 ifTrue: [ ^ self readBody: message withSize: contentLength fromStream: aStream ].
	
	transferEncodings := message transferEncoding.
	(transferEncodings anySatisfy: [ :value | value = 'chunked' ]) ifTrue: [ ^ self readBodyChunked: message fromStream: aStream ].
]

{ #category : #running }
AmaSession >> readBody: message withSize: size fromStream: aStream [

	| payload |
	payload := ByteString new: size.
	aStream next: size into: payload.
	message body: payload.
]

{ #category : #running }
AmaSession >> readBodyChunked: message fromStream: aStream [

	| buffer sz first |
	
	buffer := WriteStream on: String new.
	first := true.
	sz := 0.
	
	[ first | (sz > 0) ] whileTrue: [
		first := false.
		sz := (aStream upToAll: String crlf) asInteger.
		buffer nextPutAll: (aStream next: sz).
		aStream upToAll: String crlf.
	].

	message body: buffer contents 
	
]

{ #category : #running }
AmaSession >> readRequest [

	| request nextLine |
	
	"HTTP requests are textual, so put the stream in ASCII mode"
	request := AmaRequest new.
	nextLine := self clientStream upToAll: String crlf.
	request statusLine: nextLine.
	
	"headers"
	nextLine := self clientStream upToAll: String crlf.
	[ nextLine isNotEmpty ] whileTrue: [
		| ix name value |
		ix := nextLine findString: ':'.
		ix > 0 ifTrue: [ 
			name := nextLine first: ix-1.
			value := nextLine allButFirst: ix.
			request headers at: name trimBoth put: value trimBoth ].
		nextLine := self clientStream upToAll: String crlf ].

	"request bodies are binary (that is, are not ASCII-only)."
	self readBody: request fromStream: self clientStream.
	
	^ request.
	
	
	
]

{ #category : #running }
AmaSession >> run [
	"The main routine responsible for processing a Transaction.  It will coordinate reading the client's request,
	forwarding it to the server, reading the server's response, and returning that to the client.  If the client
	requests a TLS session (via a CONNECT request), we'll convert into a dumb pipe, shoveling raw bytes to and fro."

	|request response|
	request := self readRequest.
	request ifNil: [ ^ self ].

	(request method) = 'CONNECT'
		ifTrue: [ ^ self runTlsPipe ].
	
	request stripHttpUpgradeIfPresent.
	self forwardRequestToServer: request.
	
	response := self readResponseFromServer.
	self forwardResponseToClient: response.
	
	self close.
]

{ #category : #running }
AmaSession >> runTlsPipe [

	| mux isOpen checkBlock closeBlock |
	mux := Mutex new.
	isOpen := true.
	
	clientStream binary.
	serverStream binary.
	
	checkBlock := [ mux critical: [ isOpen ] ].
	closeBlock := [ mux critical: [ isOpen := false ] ].

	[ [ serverStream socket sendStreamContents: clientStream checkBlock: checkBlock ] on: ConnectionClosed do: closeBlock ] fork.
	[ [ clientStream socket sendStreamContents: serverStream checkBlock: checkBlock ] on: ConnectionClosed do: closeBlock ] fork.
]
