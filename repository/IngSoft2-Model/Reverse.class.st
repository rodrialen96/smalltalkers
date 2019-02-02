Class {
	#name : #Reverse,
	#superclass : #InstantaneousCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Reverse >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard)
]

{ #category : #accessing }
Reverse >> name [
	^ 'Reverse'
]

{ #category : #playing }
Reverse >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	aGame invertOrderOfPlayers.
	aGame updateOrderOfPlayers
]

{ #category : #assigning }
Reverse >> selectCardTarget: aCardName [
	target := aCardName
]
