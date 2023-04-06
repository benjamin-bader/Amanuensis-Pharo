"
An AmaHeaderDictionaryTest is a test class for testing the behavior of AmaHeaderDictionary
"
Class {
	#name : #AmaHeaderDictionaryTest,
	#superclass : #TestCase,
	#category : #'Amanuensis-Tests'
}

{ #category : #tests }
AmaHeaderDictionaryTest >> testAtPut [

	| d |
	d := AmaHeaderDictionary new.
	d at: 'foo' put: 'bar'.
	self assert: (d at: 'Foo') equals: (OrderedCollection newFrom: #('bar')).
	self assert: (d at: 'fOO') equals: (OrderedCollection newFrom: #('bar')).
]

{ #category : #tests }
AmaHeaderDictionaryTest >> testCanonicalNameFor [

	| d |
	d := AmaHeaderDictionary new.
	self assert: (d canonicalNameFor: 'abcdefg') equals: 'Abcdefg'.
	self assert: (d canonicalNameFor: 'Foo-Bar') equals: 'Foo-Bar'.
	self assert: (d canonicalNameFor: 'fOO-bAR') equals: 'Foo-Bar'.
	self assert: (d canonicalNameFor: 'foo--bar') equals: 'Foo--Bar'.
]

{ #category : #tests }
AmaHeaderDictionaryTest >> testDo [

	| d expected |
	d := AmaHeaderDictionary new.
	d at: 'foo' put: 'bar'.
	d at: 'foo' put: 'baz'.
	d at: 'foo' put: 'qux'.
	d at: 'Content-Type' put: 'test'.
	
	expected := Set new add: 'Foo'; add: 'Content-Type'; yourself.
	
	d do: [ :header :values |
		self assert: (expected includes: header) equals: true.
		expected remove: header.
		
		header = 'Foo' ifTrue: [ self assert: values equals: (OrderedCollection newFrom: #( 'bar' 'baz' 'qux' )) ].
		header = 'Content-Type' ifTrue: [ self assert: values equals: (OrderedCollection newFrom: #( 'test' )) ] ]
	
]
