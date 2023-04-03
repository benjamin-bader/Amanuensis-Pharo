"
I am an HTTP proxy that makes requests and responses available to listeners as they happen, for inspection and in-flight modification.
"
Class {
	#name : #AmaProxy,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #Amanuensis
}

{ #category : #accessing }
AmaProxy >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'action handling' }
AmaProxy >> listenForTransactions: aFullBlockClosure [

	self announcer
		when: AmaTransactionStarted
		do: [ :e | aFullBlockClosure value: e transaction ]
]

{ #category : #'event testing' }
AmaProxy >> simulateTransaction [

	self announcer announce: AmaTransactionStarted new
]
