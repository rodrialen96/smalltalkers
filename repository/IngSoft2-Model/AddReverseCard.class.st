Class {
	#name : #AddReverseCard,
	#superclass : #AddCard,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
AddReverseCard >> applyTo: aPlayer on: aGame [
	aGame player: aPlayer addCard: Reverse new
]
