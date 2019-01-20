Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'target'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Card >> addTo: cardsHistory to: anotherPlayer with: aCard [
	self subclassResponsibility

]

{ #category : #playing }
Card >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	self subclassResponsibility
]

{ #category : #assigning }
Card >> selectCardTarget: aCardName [
	^ self subclassResponsibility
]
