Class {
	#name : #Cancellation,
	#superclass : #InstantaneousCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Cancellation >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard)
]

{ #category : #testing }
Cancellation >> assertEmptyTarget [
	target = 'none'
		ifTrue: [ GameException signal: 'You have to declare a target first' ]

]

{ #category : #testing }
Cancellation >> assertPermanentCard [
	(target isKindOf: PermanentCard)
		ifFalse: [ GameException signal: 'The target must be a Permanent Card' ]

]

{ #category : #initialization }
Cancellation >> initialize [
	target := 'none'
]

{ #category : #accessing }
Cancellation >> name [
	^ 'Cancellation'
]

{ #category : #playing }
Cancellation >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	self assertEmptyTarget.
	self assertPermanentCard.
	aGame cancelCard: target from: aPlayer to: anotherPlayer
]

{ #category : #assigning }
Cancellation >> selectCardTarget: aCard [
	target := aCard
]
