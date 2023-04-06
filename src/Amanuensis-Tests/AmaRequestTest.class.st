"
An AmaRequestTest is a test class for testing the behavior of AmaRequest
"
Class {
	#name : #AmaRequestTest,
	#superclass : #TestCase,
	#category : #'Amanuensis-Tests'
}

{ #category : #tests }
AmaRequestTest >> testMethod [

	| r |
	r := AmaRequest new statusLine: 'POST /foo/bar HTTP/1.1'.
	self assert: r method equals: 'POST'.
]

{ #category : #tests }
AmaRequestTest >> testPath [

	| r |
	r := AmaRequest new statusLine: 'POST /foo/bar HTTP/1.1'.
	self assert: r path equals: '/foo/bar'.
]
