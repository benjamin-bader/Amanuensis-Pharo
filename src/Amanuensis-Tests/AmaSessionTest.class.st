Class {
	#name : #AmaSessionTest,
	#superclass : #TestCase,
	#category : #'Amanuensis-Tests'
}

{ #category : #tests }
AmaSessionTest >> testReadRequest_happyPath [

	| session request |
	session := AmaSession new clientStream: (ReadStream on: 'POST /foo/bar HTTP/1.1', String crlf, 'Content-Type: text/plain', String crlf, 'Content-Length: 11', String crlf, String crlf, 'hello there').
	request := session readRequest.
	
	self assert: request method equals: 'POST'.
	self assert: request path equals: '/foo/bar'.
	self assert: request body equals: 'hello there'.
]

{ #category : #tests }
AmaSessionTest >> testReadRequest_happyPath_chunked [

	| session content request |
	content := #(
		'POST /foo/bar HTTP/1.1'
		'Content-Type: application/json'
		'Transfer-Encoding: chunked'
		''
		'2'
		'{}'
		'0'
		''
	) joinUsing: String crlf.
	session := AmaSession new clientStream: (ReadStream on: content).
	request := session readRequest.
	
	self assert: request body asString equals: '{}'.
]

{ #category : #tests }
AmaSessionTest >> testReadingFromStreams [

	| stream |
	stream := ReadStream on: 'PUT /foo/bar HTTP/1.1', String crlf, 'Host: foo.com', String crlf, String crlf.
	self assert: (stream upToAll: String crlf) equals: 'PUT /foo/bar HTTP/1.1'.
	self assert: (stream upToAll: String crlf) equals: 'Host: foo.com'.
	self assert: (stream upToAll: String crlf) equals: ''.
]
