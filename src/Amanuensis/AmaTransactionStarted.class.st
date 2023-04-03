"
I announce to all and sundry that a new Transaction has started.
"
Class {
	#name : #AmaTransactionStarted,
	#superclass : #Announcement,
	#instVars : [
		'transaction'
	],
	#category : #Amanuensis
}

{ #category : #accessing }
AmaTransactionStarted >> transaction [

	^ transaction
]
