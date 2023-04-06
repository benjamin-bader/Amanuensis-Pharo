"
An AmaHttpMessageTest is a test class for testing the behavior of AmaHttpMessage
"
Class {
	#name : #AmaHttpMessageTest,
	#superclass : #TestCase,
	#category : #'Amanuensis-Tests'
}

{ #category : #tests }
AmaHttpMessageTest >> testBody [

	| m bytes stream |
	bytes := ByteArray newFrom: #(1 2 3 4 5).
	stream := ReadWriteStream with: #(6 7 8 9 0).
	
	m := AmaHttpMessage new.
	m body: bytes.
	self assert: m body equals: #[1 2 3 4 5].
	
]
