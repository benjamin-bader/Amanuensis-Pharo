"
I am a dictionary specialized for storing HTTP headers and their values.

I am a ""multi-dictionary"" - I store multiple values for each header.  Headers are stored in a canonical form,
where the intial character of the name and each character following a hyphen are uppercased, and the rest are
lowercased (e.g. 'Foo-Bar' would be the canonical form for the name 'foo-bar').  For each unique header name,
I store an OrderedCollection of values.
"
Class {
	#name : #AmaHeaderDictionary,
	#superclass : #Object,
	#instVars : [
		'names',
		'values'
	],
	#category : #Amanuensis
}

{ #category : #accessing }
AmaHeaderDictionary >> at: aHeader [

	| res |
	res := values at: (self canonicalNameFor: aHeader) ifAbsent: [ nil ].
	^ res ifNil: [ OrderedCollection new: 0 ]
]

{ #category : #accessing }
AmaHeaderDictionary >> at: aHeader put: aValue [

	| canon existing |
	canon := self canonicalNameFor: aHeader.
	existing := values at: canon ifAbsentPut: [ OrderedCollection new ].
	existing ifEmpty: [ names add: canon ].
	existing add: aValue
]

{ #category : #'name utilities' }
AmaHeaderDictionary >> canonicalNameFor: aHeaderName [

	| out capitalizeNextLetter |
	out := WriteStream on: (String new: aHeaderName size).

	capitalizeNextLetter := true.
	aHeaderName do: [ :eachChar | 
		eachChar isLetter
			ifTrue: [ 
				capitalizeNextLetter
					ifTrue: [ 
						out nextPut: eachChar asUppercase.
						capitalizeNextLetter := false ]
					ifFalse: [ out nextPut: eachChar asLowercase ] ]
			ifFalse: [ 
				out nextPut: eachChar.
				capitalizeNextLetter := true ] ].

	^ out contents
]

{ #category : #enumerating }
AmaHeaderDictionary >> do: aBlock [

	values associationsDo: [:association | aBlock value: association key value: association value ]
]

{ #category : #testing }
AmaHeaderDictionary >> hasHeaderNamed: aHeaderName [

	^ values includesKey: (self canonicalNameFor: aHeaderName)
]

{ #category : #initialization }
AmaHeaderDictionary >> initialize [

	names := OrderedCollection new.
	values := Dictionary new.

]
