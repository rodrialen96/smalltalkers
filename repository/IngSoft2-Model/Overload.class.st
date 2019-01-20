Class {
	#name : #Overload,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Overload >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard) 
]

{ #category : #accessing }
Overload >> name [
	^ 'Overload'
]

{ #category : #playing }
Overload >> player: aPlayer cancelEffectTo: anotherPlayer on: aGame [
	aGame modifyCardEffectAdvanceNumberOf: anotherPlayer with: 2
]

{ #category : #playing }
Overload >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	aGame assertIsTurnOf: aPlayer.
	aGame modifyCardEffectGoBackNumberOf: anotherPlayer with: 2
]

{ #category : #assigning }
Overload >> selectCardTarget: aCardName [
	target := aCardName
]
