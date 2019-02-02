Class {
	#name : #Skip,
	#superclass : #InstantaneousCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Skip >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard)
]

{ #category : #accessing }
Skip >> name [
	^ 'Skip'
]

{ #category : #playing }
Skip >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	aGame changeTurn
]

{ #category : #assigning }
Skip >> selectCardTarget: aCardName [
	target := aCardName
]
