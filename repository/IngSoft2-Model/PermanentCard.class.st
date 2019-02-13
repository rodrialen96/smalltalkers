Class {
	#name : #PermanentCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
PermanentCard >> player: arg1 cancelEffectTo: arg2 on: arg3 [ 
	^ self subclassResponsibility
]

{ #category : #playing }
PermanentCard >> player: aPlayer useAgainst: anotherPlayer on: aGame [
	self subclassResponsibility
]
