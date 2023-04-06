"
A ProxyTest is a test class for testing the behavior of Proxy
"
Class {
	#name : #AmaProxyTest,
	#superclass : #TestCase,
	#category : #'Amanuensis-Tests'
}

{ #category : #tests }
AmaProxyTest >> testAnnouncer [

	| p |
	p := AmaProxy new.
	self deny: p announcer isNil.
	self assert: p announcer identicalTo: p announcer
]

{ #category : #tests }
AmaProxyTest >> testDefaultPort [

	self assert: AmaProxy defaultPort equals: 9999
]

{ #category : #tests }
AmaProxyTest >> testIsRunning [

	| p |
	p := AmaProxy new.
	self assert: p isRunning equals: false.
	p isRunning: true.
	self assert: p isRunning equals: true
]

{ #category : #tests }
AmaProxyTest >> testListenForTransactions [

	| p called |
	p := AmaProxy new.
	called := false.
	p listenForTransactions: [ :tx | called := true ].

	p simulateTransaction.

	self assert: called equals: true
]

{ #category : #tests }
AmaProxyTest >> testListenSocket [

	| p |
	p := AmaProxy new.
	self assert: p listenSocket isNil.
	p listenSocket: Socket newTCP.
	self assert: p listenSocket isNotNil.
]

{ #category : #tests }
AmaProxyTest >> testPort [

	| p |
	p := AmaProxy new.
	self assert: p port equals: AmaProxy defaultPort.
	p port: AmaProxy defaultPort + 1.
	self assert: p port equals: AmaProxy defaultPort + 1.
]

{ #category : #tests }
AmaProxyTest >> testStartListening [

	| p |
	p := AmaProxy new.
	self assert: p isRunning equals: false.
	self assert: p listenSocket isNil.
	p startListening.
	self assert: p isRunning equals: true.
	self assert: p listenSocket isNotNil.
]

{ #category : #tests }
AmaProxyTest >> testStartListening_opensSocket [

	| p |
	p := AmaProxy new.
	p startListening.
	self
		assert: p listenSocket statusString
		equals: 'waitingForConnection'
]

{ #category : #tests }
AmaProxyTest >> testStopListening [

	| p |
	p := AmaProxy new.
	p startListening.
	self assert: p isRunning equals: true.
	p stopListening.
	self assert: p isRunning equals: false
]

{ #category : #tests }
AmaProxyTest >> testWithPort [

	| p |
	p := AmaProxy withPort: 123.
	self assert: p port equals: 123
]
