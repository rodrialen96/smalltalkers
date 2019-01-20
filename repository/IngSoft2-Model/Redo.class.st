Class {
	#name : #Redo,
	#superclass : #Card,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Redo >> addTo: cardsHistory to: anotherPlayer with: aCard [
	
]

{ #category : #initialization }
Redo >> initialize [
	cards := OrderedCollection new
		add: Acceleration new;
		add: Overload new;
		add: Speed new;
		add: Cancellation new;
		yourself
]

{ #category : #accessing }
Redo >> name [
	^ 'Redo'
]

{ #category : #playing }
Redo >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	| effect |
	effect := aGame cardsHistory last effect.
	cards
		detect: [ :each | each name = effect ]
		ifFound: [ :found | 
			found selectCardTarget: target.
			found player: aGame turn useAgainst: anotherPlayer on: aGame ]
]

{ #category : #assigning }
Redo >> selectCardTarget: aCardName [
	target := aCardName
]
