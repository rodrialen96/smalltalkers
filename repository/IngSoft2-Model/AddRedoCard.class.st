Class {
	#name : #AddRedoCard,
	#superclass : #AddCard,
	#category : #'IngSoft2-Model'
}

{ #category : #applying }
AddRedoCard >> applyTo: aPlayer on: aGame [
	aGame player: aPlayer addCard: Redo new
]
