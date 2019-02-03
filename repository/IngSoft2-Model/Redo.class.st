Class {
	#name : #Redo,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Redo >> addTo: cardsHistory to: anotherPlayer with: aCard [
	
]

{ #category : #accessing }
Redo >> name [
	^ 'Redo'
]

{ #category : #playing }
Redo >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	| card |
	card := aGame cardsHistory last card.
	card selectCardTarget: target.
	card player: aGame turn useAgainst: anotherPlayer on: aGame
]

{ #category : #assigning }
Redo >> selectCardTarget: aCard [
	target := aCard
]
