Class {
	#name : #PermanentCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #playing }
PermanentCard >> fromPlayer: aPlayer applyCancelEffectTo: anotherPlayer on: aGame [
	self subclassResponsibility
]

{ #category : #playing }
PermanentCard >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	self subclassResponsibility
]
