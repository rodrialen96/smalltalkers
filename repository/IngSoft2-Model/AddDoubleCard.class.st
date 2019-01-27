Class {
	#name : #AddDoubleCard,
	#superclass : #AddCard,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
AddDoubleCard >> applyTo: aPlayer on: aGame [
	aGame player: aPlayer addCard: Double new
]
