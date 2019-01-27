Class {
	#name : #AddSkipCard,
	#superclass : #AddCard,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
AddSkipCard >> applyTo: aPlayer on: aGame [
	aGame player: aPlayer addCard: Skip new
]
