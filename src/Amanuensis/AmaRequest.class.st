"
I represent an HTTP request.
"
Class {
	#name : #AmaRequest,
	#superclass : #AmaHttpMessage,
	#instVars : [
		'method',
		'path'
	],
	#category : #Amanuensis
}

{ #category : #accessing }
AmaRequest >> method [

	^ method ifNil: [ method := (statusLine splitOn: ' ') at: 1 ]
]

{ #category : #accessing }
AmaRequest >> path [

	^ path ifNil: [ path := (statusLine splitOn: ' ') at: 2 ]
	
]

{ #category : #accessing }
AmaRequest >> statusLine: aStatusLine [

	| parts |
	super statusLine: aStatusLine.
	parts := aStatusLine splitOn: ' '.
	method := parts at: 1.
	path := parts at: 2.
]
