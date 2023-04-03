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
