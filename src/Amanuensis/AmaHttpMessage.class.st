"
I am an abstract class representing HTTP messages; my subclasses AmaRequest and AmaResponse represent HTTP requests and responses, respectively.
"
Class {
	#name : #AmaHttpMessage,
	#superclass : #Object,
	#instVars : [
		'statusLine',
		'protocolVersion',
		'headers',
		'body'
	],
	#category : #Amanuensis
}

{ #category : #testing }
AmaHttpMessage class >> isAbstract [
		
	^ self == AmaHttpMessage
]

{ #category : #accessing }
AmaHttpMessage >> atHeader: aHeader put: aValue [

	headers at: aHeader put: aValue
]

{ #category : #accessing }
AmaHttpMessage >> body [
	^ body
]

{ #category : #accessing }
AmaHttpMessage >> body: aCollection [ 
	body := aCollection 
]

{ #category : #accessing }
AmaHttpMessage >> contentLength [

	| values |
	values := self headers at: 'Content-Length'.
	values isEmpty
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ (values at: 1) asInteger ]
]

{ #category : #accessing }
AmaHttpMessage >> headers [

	^ headers
]

{ #category : #initialization }
AmaHttpMessage >> initialize [

	super initialize.
	headers := AmaHeaderDictionary new.
]

{ #category : #accessing }
AmaHttpMessage >> statusLine: aString [ 
	statusLine := aString
]

{ #category : #streaming }
AmaHttpMessage >> streamOn: aStream [

	| needsComma |
	aStream nextPutAll: statusLine.
	aStream crlf.

	headers do: [ :name :values | 
		aStream << name << ': '.
		needsComma := false.
		values do: [ :value | 
			needsComma ifTrue: [ aStream << ', ' ].
			aStream << value.
			needsComma := true ].
		aStream << String crlf ].

	aStream << String crlf.

	body empty ifFalse: [ aStream << body ].
	aStream flush
]

{ #category : #accessing }
AmaHttpMessage >> transferEncoding [

	^ self headers at: 'Transfer-Encoding'
]
