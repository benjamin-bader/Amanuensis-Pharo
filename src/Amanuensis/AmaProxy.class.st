"
I am an HTTP proxy that makes requests and responses available to listeners as they happen, for inspection and in-flight modification.
"
Class {
	#name : #AmaProxy,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'mutex',
		'isRunning',
		'listenSocket',
		'port'
	],
	#category : #Amanuensis
}

{ #category : #accessing }
AmaProxy class >> defaultPort [
	"The port on which an AmaProxy will listen, if no other port is specified."

	^ 9999
]

{ #category : #factory }
AmaProxy class >> withPort: anInteger [ 
	^ self new port: anInteger
]

{ #category : #visiting }
AmaProxy >> acceptWhileRunning [

	| clientSocket |
	[ 
		[ self isRunning ] whileTrue: [ 
			clientSocket := self listenSocket accept.
			[ 
			(AmaSession forClient: clientSocket)
				announcer: self announcer;
				run
			] fork
		]
	] ensure: [ self listenSocket close ]
]

{ #category : #accessing }
AmaProxy >> announcer [

	mutex critical: [^ announcer ifNil: [ announcer := Announcer new ] ]
]

{ #category : #initialization }
AmaProxy >> initialize [

	super initialize.
	mutex := Mutex new.
	isRunning := false.
]

{ #category : #accessing }
AmaProxy >> isRunning [
	mutex critical: [ ^ isRunning ]
]

{ #category : #'private - accessing' }
AmaProxy >> isRunning: aBoolean [ 
	mutex critical: [ isRunning := aBoolean ]
]

{ #category : #'action handling' }
AmaProxy >> listenForTransactions: aFullBlockClosure [

	self announcer
		when: AmaTransactionStarted
		do: [ :e | aFullBlockClosure value: e transaction ]
]

{ #category : #accessing }
AmaProxy >> listenSocket [
	^ listenSocket
]

{ #category : #'private - accessing' }
AmaProxy >> listenSocket: aSocket [ 
	listenSocket := aSocket
]

{ #category : #accessing }
AmaProxy >> port [

	^ port ifNil: [ port := self class defaultPort ]
]

{ #category : #'private - accessing' }
AmaProxy >> port: anInteger [ 
	port := anInteger
]

{ #category : #'event testing' }
AmaProxy >> simulateTransaction [

	self announcer announce: AmaTransactionStarted new
]

{ #category : #'performing service' }
AmaProxy >> startListening [

	mutex critical: [ 
		self isRunning ifTrue: [ ^ self ].
		self isRunning: true ].
	listenSocket := Socket newTCP.
	listenSocket listenOn: self port backlogSize: 64.
	[ self acceptWhileRunning ] forkAt: Processor userBackgroundPriority
]

{ #category : #'performing service' }
AmaProxy >> stopListening [
	mutex critical: [ 
		self isRunning ifFalse: [ ^ self ].
		self isRunning: false ].
]
