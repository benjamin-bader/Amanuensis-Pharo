"
I am a baseline for Amanuensis.
"
Class {
	#name : #BaselineOfAmanuensis,
	#superclass : #BaselineOf,
	#category : #BaselineOfAmanuensis
}

{ #category : #baselines }
BaselineOfAmanuensis >> baseline: spec [

	<baseline>
	super baseline: spec.
	spec for: #common do: [
		"packages"
		spec
			package: 'Amanuensis';
			package: 'Amanuensis-Tests' with: [ spec requires: #( 'Amanuensis' ) ] ]
]

{ #category : #accessing }
BaselineOfAmanuensis >> projectClass [

	^ MetacelloCypressBaselineProject
]
