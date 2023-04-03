"
I am an HTTP proxy that makes requests and responses available to listeners as they happen, for inspection and in-flight modification.
"
Class {
	#name : #AmaProxy,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'mutex',
		'isRunning'
	],
	#category : #Amanuensis
}

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

{ #category : #'event testing' }
AmaProxy >> simulateTransaction [

	self announcer announce: AmaTransactionStarted new
]
