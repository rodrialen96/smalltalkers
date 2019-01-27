Class {
	#name : #Double,
	#superclass : #InstantaneousCard,
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
Double >> addTo: cardsHistory to: anotherPlayer with: aCard [
	cardsHistory add: (CardHistory to: anotherPlayer with: aCard)
]

{ #category : #accessing }
Double >> name [
	^ 'Double'
]

{ #category : #playing }
Double >> player: aPlayer useAgainst: anotherPlayer on: aGame [

]
