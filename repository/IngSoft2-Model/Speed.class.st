Class {
	#name : #Speed,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Speed >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard)
]

{ #category : #accessing }
Speed >> name [
	^ 'Speed'
]

{ #category : #playing }
Speed >> player: aPlayer cancelEffectTo: anotherPlayer on: aGame [
	aGame modifyCardEffectGoBackNumberOf: anotherPlayer with: 1
]

{ #category : #playing }
Speed >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	aGame assertIsTurnOf: aPlayer.
	aGame modifyCardEffectAdvanceNumberOf: anotherPlayer with: 1
]

{ #category : #assigning }
Speed >> selectCardTarget: aCardName [
	target := aCardName
]
