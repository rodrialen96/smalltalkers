Class {
	#name : #CardHistory,
	#superclass : #History,
	#instVars : [
		'target',
		'card'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
CardHistory class >> to: destinyPlayer with: aCard [
	^ self new to: destinyPlayer with: aCard
]

{ #category : #accessing }
CardHistory >> card [
	^ card
]

{ #category : #accessing }
CardHistory >> cardName [
	^ card name
]

{ #category : #accessing }
CardHistory >> targetName [
	^ target
]

{ #category : #initialization }
CardHistory >> to: anAffectedPlayer with: aCard [
	target := anAffectedPlayer name.
	card := aCard
]
