Class {
	#name : #GameSmalltalkersTest,
	#superclass : #TestCase,
	#instVars : [
		'rodri',
		'fran',
		'players',
		'diceCollection',
		'dice'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'test-support' }
GameSmalltalkersTest >> gamedWithDiceSequence: diceSequence andEffectSequence: effectSequence [
	dice := Dice faces: 4 withStrategy: (LoadedStrategy withSequence: diceSequence).
	diceCollection := OrderedCollection new
		add: dice;
		add: dice;
		yourself.
	^ GameSmalltalkers
		playedBy: players
		onBoard: (Board effects: effectSequence)
		withDices: diceCollection
		withWinningLaps: 2.
]

{ #category : #running }
GameSmalltalkersTest >> setUp [
	| rodriCardCollection franCardCollection overloadRodri overloadFran speedFran speedRodri |
	speedRodri := Speed new.
	speedFran := Speed new.
	overloadRodri := Overload new.
	overloadFran := Overload new.
	rodriCardCollection := OrderedCollection new
		add: overloadRodri;
		add: speedRodri;
		yourself.
	franCardCollection := OrderedCollection new
		add: overloadFran;
		add: speedFran;
		yourself.
	rodri := Player named: 'Rodri' with: rodriCardCollection.
	fran := Player named: 'Fran' with: franCardCollection.
	players := OrderedCollection new
		add: rodri;
		add: fran;
		yourself
]

{ #category : #tests }
GameSmalltalkersTest >> testAdvancePlayer [
	| speedUp wormHole effectSequence game |
	speedUp := SpeedUp new.
	wormHole := WormHole new.
	effectSequence := OrderedCollection new
		add: wormHole;
		add: wormHole;
		add: speedUp;
		yourself.
	game := self gamedWithDiceSequence: #(1 2 3 4) andEffectSequence: effectSequence.
	self assert: (game positionOf: rodri) equals: 0.
	game player: rodri advance: 5.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game lapsOf: rodri) equals: 1.
	game player: rodri advance: 2.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game lapsOf: rodri) equals: 2.
	game player: rodri advance: 1.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game lapsOf: rodri) equals: 2.
	game player: rodri advance: 1.
	self assert: (game positionOf: rodri) equals: 0.
	self assert: (game lapsOf: rodri) equals: 3.
	game player: rodri goBack: 1.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game lapsOf: rodri) equals: 2.
	game player: rodri goBack: 3.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game lapsOf: rodri) equals: 1.
	game player: rodri goBack: 1.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game lapsOf: rodri) equals: 1.
	game player: rodri goBack: 4.
	self assert: (game positionOf: rodri) equals: 0.
	self assert: (game lapsOf: rodri) equals: 0.
	game player: rodri goBack: 6.
	self assert: (game positionOf: rodri) equals: 0.
	self assert: (game lapsOf: rodri) equals: -2
]

{ #category : #tests }
GameSmalltalkersTest >> testChangingTurn [
	| speedUp wormHole effectSequence game |
	speedUp := SpeedUp new.
	wormHole := WormHole new.
	effectSequence := OrderedCollection new
		add: wormHole;
		add: wormHole;
		add: speedUp;
		yourself.
	game := self gamedWithDiceSequence: #(1 2 3 4) andEffectSequence: effectSequence.
	self assert: game turn equals: rodri.
	self
		should: [ game play: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	game changeTurn.
	self assert: game turn equals: fran.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ]
]

{ #category : #tests }
GameSmalltalkersTest >> testInstanceCreationGameAndAccesing [
	| game speedUp wormHole effectSequence |
	speedUp := SpeedUp new.
	wormHole := WormHole new.
	effectSequence := OrderedCollection new
		add: wormHole;
		add: wormHole;
		add: speedUp;
		yourself.
	game := self gamedWithDiceSequence: #(1 3 5 7) andEffectSequence: effectSequence.
	self assert: game hasEnded equals: false
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithAccelerationCard [
	| game effectSequence addAccelerationCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addAccelerationCard := AddAccelerationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addAccelerationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Acceleration new against: 'all'.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 5.
	self assert: (game positionOf: fran) equals: 3.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 5.
	self assert: (game positionOf: fran) equals: 7.
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithCancellationCard [
	| game effectSequence addCancellationCard withoutEffect addAcelerationCard |
	withoutEffect := WithoutEffect new.
	addCancellationCard := AddCancellationCard new.
	addAcelerationCard := AddAccelerationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addAcelerationCard;
		add: addCancellationCard;
		add: addCancellationCard;
		add: addCancellationCard;
		add: addCancellationCard;
		add: addAcelerationCard;
		add: addCancellationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(2 2 2 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 16.
	game play: rodri.
	self assert: game turn equals: fran.
	self assert: (game positionOf: rodri) equals: 4.
	game play: fran.
	self assert: (game positionOf: fran) equals: 4.
	game player: fran targetForCancellationCardIs: Overload new.
	self
		should: [ game player: fran useCard: Cancellation new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'That player is not affected by that card' ].
	game player: rodri targetForCancellationCardIs: Overload new.
	self
		should: [ game player: rodri useCard: Cancellation new against: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'That player is not affected by that card' ].
	self assert: game turn equals: rodri.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: fran useCard: Overload new against: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	self assert: (game positionOf: fran) equals: 4.
	game play: rodri.
	game player: fran useCard: Speed new against: rodri.
	self assert: game turn equals: fran.
	self assert: (game positionOf: rodri) equals: 8.
	self assert: (game positionOf: fran) equals: 4.
	game player: fran targetForCancellationCardIs: Overload new.
	game player: fran useCard: Cancellation new against: fran.
	game player: rodri targetForCancellationCardIs: Speed new.
	game player: rodri useCard: Cancellation new against: rodri.
	game play: fran.
	self assert: (game positionOf: fran) equals: 8.
	self
		should: [ game player: rodri useCard: Overload new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	game player: fran useCard: Overload new against: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	game play: fran.
	self assert: (game positionOf: fran) equals: 12.
	self assert: (game positionOf: rodri) equals: 12.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 14.
	self assert: (game positionOf: fran) equals: 12.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 14.
	self assert: (game positionOf: fran) equals: 0.
	game player: rodri useCard: Acceleration new against: 'all'.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game positionOf: fran) equals: 5.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 5.
	game player: fran targetForCancellationCardIs: Acceleration new.
	game player: fran useCard: Cancellation new against: 'all'.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 9.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	self assert: (game positionOf: fran) equals: 9
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithCards [
	| game effectSequence addCancellationCard withoutEffect addAcelerationCard addSpeedCard addOverloadCard addRedoCard addRepeatCard speedUp ranking |
	withoutEffect := WithoutEffect new.
	speedUp := SpeedUp new.
	addCancellationCard := AddCancellationCard new.
	addAcelerationCard := AddAccelerationCard new.
	addSpeedCard := AddSpeedCard new.
	addOverloadCard := AddOverloadCard new.
	addRedoCard := AddRedoCard new.
	addRepeatCard := AddRepeatCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addAcelerationCard;
		add: addCancellationCard;
		add: speedUp;
		add: addRedoCard;
		add: addCancellationCard;
		add: withoutEffect;
		add: addCancellationCard;
		add: addRepeatCard;
		add: withoutEffect;
		add: addSpeedCard;
		add: addSpeedCard;
		add: addOverloadCard;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(2 2 2 3) andEffectSequence: effectSequence.
	self assert: game board length equals: 16.
	game play: rodri.
	self assert: game turn equals: fran.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: game turn equals: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 9.
	game player: rodri useCard: Speed new against: rodri.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: fran targetForCancellationCardIs: Overload new ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have Cancellation Card' ].
	game play: rodri.
	self assert: game turn equals: fran.
	self assert: (game positionOf: rodri) equals: 9.
	self assert: (game positionOf: fran) equals: 9.
	game player: fran useCard: Overload new against: rodri.
	game play: fran.
	self assert: game turn equals: rodri.
	self assert: (game positionOf: rodri) equals: 9.
	self assert: (game positionOf: fran) equals: 12.
	game play: rodri.
	self assert: game turn equals: fran.
	game player: fran useCard: Speed new against: fran.
	game player: rodri targetForCancellationCardIs: Overload new.
	game player: rodri useCard: Cancellation new against: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game positionOf: fran) equals: 12.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	game play: fran.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game positionOf: fran) equals: 0.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game positionOf: fran) equals: 0.
	game player: fran useCard: Speed new against: fran.
	self
		should: [ game player: fran useCard: Speed new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: fran.
	self assert: (game positionOf: rodri) equals: 1.
	self assert: (game positionOf: fran) equals: 9.
	game player: rodri targetForCancellationCardIs: Speed new.
	game player: rodri useCard: Cancellation new against: fran.
	game play: rodri.
	self assert: (game positionOf: fran) equals: 9.
	self assert: (game positionOf: rodri) equals: 6.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 6.
	self assert: (game positionOf: fran) equals: 13.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 11.
	self assert: (game positionOf: fran) equals: 13.
	game player: fran useCard: Speed new against: fran.
	game player: rodri useCard: Redo new against: rodri.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 11.
	self assert: (game positionOf: fran) equals: 2.
	self assert: (game lapsOf: fran) equals: 2.
	self assert: (game lapsOf: rodri) equals: 1.
	self assert: game hasEnded equals: true.
	self assert: game winner equals: fran.
	ranking := game rankPlayers.
	self assert: (ranking playerAtPosition: 1) equals: fran.
	self assert: (ranking playerAtPosition: 2) equals: rodri.
	self assert: (ranking scoreOf: fran) equals: 34.
	self assert: (ranking scoreOf: rodri) equals: 27
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithDoubleCard [
	| game effectSequence addDoubleCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addDoubleCard := AddDoubleCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addDoubleCard;
		add: addDoubleCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: fran useCard: Double new against: fran.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 7.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Double new against: rodri.
	self
		should: [ game player: fran useCard: Double new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: fran.
	self
		should: [ game player: rodri useCard: Double new against: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	self assert: (game positionOf: rodri) equals: 7.
	self assert: (game positionOf: fran) equals: 8
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithDoubleRedoCard [
	| game effectSequence addDoubleCard addRedoCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addDoubleCard := AddDoubleCard new.
	addRedoCard := AddRedoCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addDoubleCard;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Double new against: rodri.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 7.
	self assert: (game positionOf: fran) equals: 3.
	self
		should: [ game player: rodri useCard: Double new against: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game player: fran useCard: Redo new against: fran.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 7.
	self assert: (game positionOf: fran) equals: 8
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithEffects [
	| game effectSequence ranking wormHole speedUp moonWalk atomicBomb anotherMoonWalk withoutEffect |
	wormHole := WormHole new.
	withoutEffect := WithoutEffect new.
	speedUp := SpeedUp new.
	moonWalk := MoonWalk goBack: 1.
	atomicBomb := AtomicBomb new.
	anotherMoonWalk := MoonWalk goBack: 2.
	effectSequence := OrderedCollection new
		add: speedUp;
		add: wormHole;
		add: moonWalk;
		add: atomicBomb;
		add: anotherMoonWalk;
		add: speedUp;
		add: speedUp;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(8 2 2 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game lapsOf: rodri) equals: 1.
	self assert: game hasEnded equals: false.
	self
		should: [ game winner ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Game isnt finished' ].
	self assert: game turn equals: fran.
	game play: fran.
	self assert: (game positionOf: fran) equals: 4.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: game hasEnded equals: false.
	self assert: (game lapsOf: fran) equals: 0.
	self assert: (game lapsOf: rodri) equals: 1.
	self assert: game turn equals: rodri.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	self assert: (game lapsOf: fran) equals: 0.
	self assert: (game lapsOf: rodri) equals: 2.
	self assert: game hasEnded equals: true.
	self assert: game winner equals: rodri.
	ranking := game rankPlayers.
	self assert: (ranking playerAtPosition: 1) equals: rodri.
	self assert: (ranking playerAtPosition: 2) equals: fran.
	self assert: (ranking scoreOf: rodri) equals: 22.
	self assert: (ranking scoreOf: fran) equals: 3
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithOverloadCard [
	| game effectSequence addOverloadCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addOverloadCard := AddOverloadCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addOverloadCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Overload new against: fran.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 3.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 4.
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithPermanentCardEffectsOnly [
	| game effectSequence addOverloadCard addAccelerationCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addOverloadCard := AddOverloadCard new.
	addAccelerationCard := AddAccelerationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addAccelerationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addOverloadCard;
		add: withoutEffect;
		add: addAccelerationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(3 3 3 3) andEffectSequence: effectSequence.
	self assert: game board length equals: 20.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	game play: fran.
	self assert: (game positionOf: fran) equals: 6.
	game player: rodri useCard: Overload new against: fran.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: rodri useCard: Overload new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	game player: fran useCard: Speed new against: rodri.
	game play: fran.
	self assert: (game positionOf: fran) equals: 8.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 19.
	game player: fran useCard: Acceleration new against: 'all'.
	game play: fran.
	self assert: (game positionOf: fran) equals: 11.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 7
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithRedoCard [
	| game effectSequence addRedoCard addAccelerationCard withoutEffect addRepeatCard |
	withoutEffect := WithoutEffect new.
	addRedoCard := AddRedoCard new.
	addRepeatCard := AddRepeatCard new.
	addAccelerationCard := AddAccelerationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: addRedoCard;
		add: addAccelerationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRepeatCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: addRedoCard;
		yourself.
	game := self gamedWithDiceSequence: #(3 3 5 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 24.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	game play: fran.
	self assert: (game positionOf: fran) equals: 7.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: rodri useCard: Overload new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game player: rodri useCard: Redo new against: fran.
	self
		should: [ game player: rodri useCard: Redo new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	game player: fran useCard: Speed new against: rodri.
	game player: fran useCard: Acceleration new against: 'all'.
	game play: fran.
	self assert: (game positionOf: fran) equals: 11.
	game player: fran useCard: Redo new against: 'all'.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 21.
	game player: rodri useCard: Redo new against: 'all'.
	game play: fran.
	self assert: (game positionOf: fran) equals: 17.
	self assert: (game positionOf: rodri) equals: 21.
	game player: fran useCard: Repeat new against: rodri.
	self assert: (game positionOf: fran) equals: 17.
	self assert: (game positionOf: rodri) equals: 21.
	game play: rodri.
	self assert: (game positionOf: fran) equals: 17.
	self assert: (game positionOf: rodri) equals: 7.
	game play: fran.
	self assert: (game positionOf: fran) equals: 23.
	self assert: (game positionOf: rodri) equals: 7.
	game player: fran useCard: Redo new against: 'all'.
	self assert: (game positionOf: fran) equals: 23.
	self assert: (game positionOf: rodri) equals: 7
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithRedoCardAndCancellation [
	| game effectSequence addRedoCard withoutEffect addCancellationCard |
	withoutEffect := WithoutEffect new.
	addRedoCard := AddRedoCard new.
	addCancellationCard := AddCancellationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: addRedoCard;
		add: addCancellationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(3 3 5 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 24.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	game play: fran.
	self assert: (game positionOf: fran) equals: 7.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: rodri useCard: Overload new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game positionOf: fran) equals: 7.
	game player: fran useCard: Speed new against: fran.
	game player: fran targetForCancellationCardIs: Overload new.
	game player: fran useCard: Cancellation new against: fran.
	game player: rodri targetForRedoCancellationCardIs: Speed new.
	game player: rodri useCard: Redo new against: fran.
	self
		should: [ game player: rodri targetForRedoCancellationCardIs: Speed new ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have Redo Card' ].
	self
		should: [ game player: rodri useCard: Redo new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: fran.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game positionOf: fran) equals: 14
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithRepeatCard [
	| game effectSequence speedUp withoutEffect addRepeatCard wormHole atomicBomb |
	addRepeatCard := AddRepeatCard new.
	withoutEffect := WithoutEffect new.
	speedUp := SpeedUp new.
	wormHole := WormHole new.
	atomicBomb := AtomicBomb new.
	effectSequence := OrderedCollection new
		add: addRepeatCard;
		add: addRepeatCard;
		add: addRepeatCard;
		add: addRepeatCard;
		add: speedUp;
		add: addRepeatCard;
		add: addRepeatCard;
		add: withoutEffect;
		add: withoutEffect;
		add: atomicBomb;
		add: atomicBomb;
		add: atomicBomb;
		add: speedUp;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: wormHole;
		add: wormHole;
		add: wormHole;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(2 2 2 1) andEffectSequence: effectSequence.
	self assert: game board length equals: 24.
	self assert: (game positionOf: rodri) equals: 0.
	self assert: (game positionOf: fran) equals: 0.
	game player: rodri addCard: Repeat new.
	game player: rodri useCard: Repeat new against: rodri.
	self
		should: [ game player: rodri useCard: Repeat new against: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 8.
	game play: fran.
	self assert: (game positionOf: fran) equals: 3.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 16.
	game player: fran useCard: Repeat new against: rodri.
	self assert: (game positionOf: rodri) equals: 20.
	game play: fran.
	self assert: (game positionOf: fran) equals: 6.
	self assert: (game positionOf: rodri) equals: 20.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 0.
	self assert: (game lapsOf: rodri) equals: 1.
	game player: rodri useCard: Repeat new against: rodri.
	self assert: (game positionOf: rodri) equals: 0.
	game play: fran.
	self assert: (game positionOf: fran) equals: 0.
	self assert: (game lapsOf: fran) equals: 0.
	self assert: (game positionOf: rodri) equals: 0.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 8.
	self assert: (game lapsOf: rodri) equals: 1.
	game player: fran useCard: Repeat new against: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game lapsOf: rodri) equals: 1.
	self assert: (game positionOf: fran) equals: 0.
	self assert: (game lapsOf: fran) equals: 0
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithReverseCard [
	| game effectSequence addReverseCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addReverseCard := AddReverseCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addReverseCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	game player: rodri useCard: Reverse new against: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 5
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithReverseRedoCard [
	| game effectSequence addReverseCard addRedoCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addReverseCard := AddReverseCard new.
	addRedoCard := AddRedoCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addReverseCard;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	game player: rodri useCard: Reverse new against: fran.
	game player: fran useCard: Redo new against: 'all'.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	self
		should: [ game play: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 3
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithSkipCard [
	| game effectSequence addSkipCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addSkipCard := AddSkipCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addSkipCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Skip new against: fran.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 5
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithSkipRedoCard [
	| game effectSequence addSkipCard addRedoCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addSkipCard := AddSkipCard new.
	addRedoCard := AddRedoCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addSkipCard;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 4.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Skip new against: fran.
	game player: fran useCard: Redo new against: 'all'.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ]
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithSpeedCard [
	| game effectSequence addSpeedCard withoutEffect |
	withoutEffect := WithoutEffect new.
	addSpeedCard := AddSpeedCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: addSpeedCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(1 1 1 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 0.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 2.
	self assert: (game positionOf: fran) equals: 3.
	game player: rodri useCard: Speed new against: rodri.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 5.
	self assert: (game positionOf: fran) equals: 3.
	game play: fran.
	self assert: (game positionOf: rodri) equals: 5.
	self assert: (game positionOf: fran) equals: 6.
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingGameWithoutEffects [
	| game effectSequence ranking withoutEffect |
	withoutEffect := WithoutEffect new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(5 3 5 7) andEffectSequence: effectSequence.
	self assert: game board length equals: 10.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 8.
	self assert: game hasEnded equals: false.
	self assert: game turn equals: fran.
	game play: fran.
	self assert: (game positionOf: fran) equals: 2.
	self assert: game hasEnded equals: false.
	self assert: game turn equals: rodri.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	self assert: (game lapsOf: rodri) equals: 1.
	self assert: game hasEnded equals: false.
	self assert: game turn equals: fran.
	self
		should: [ game play: rodri ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'it is not your turn' ].
	game play: fran.
	self assert: (game positionOf: fran) equals: 4.
	self assert: (game lapsOf: fran) equals: 2.
	self assert: game turn equals: rodri.
	self assert: game hasEnded equals: true.
	self assert: game winner equals: fran.
	ranking := game rankPlayers.
	self assert: (ranking playerAtPosition: 1) equals: fran.
	self assert: (ranking playerAtPosition: 2) equals: rodri.
	self assert: (ranking scoreOf: fran) equals: 24.
	self assert: (ranking scoreOf: rodri) equals: 16
]

{ #category : #tests }
GameSmalltalkersTest >> testPlayingWithoutPermanentsCardUsingCancellationCard [
	| game effectSequence addRedoCard withoutEffect addCancellationCard |
	withoutEffect := WithoutEffect new.
	addRedoCard := AddRedoCard new.
	addCancellationCard := AddCancellationCard new.
	effectSequence := OrderedCollection new
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: addRedoCard;
		add: addCancellationCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: withoutEffect;
		add: addRedoCard;
		add: withoutEffect;
		add: withoutEffect;
		yourself.
	game := self gamedWithDiceSequence: #(3 3 5 2) andEffectSequence: effectSequence.
	self assert: game board length equals: 24.
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 6.
	game play: fran.
	self assert: (game positionOf: fran) equals: 7.
	game player: rodri useCard: Overload new against: fran.
	self
		should: [ game player: rodri useCard: Overload new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'You dont have that card' ].
	game play: rodri.
	self assert: (game positionOf: rodri) equals: 12.
	self assert: (game positionOf: fran) equals: 7.
	game player: fran useCard: Speed new against: fran.
	game player: fran targetForCancellationCardIs: Overload new.
	game player: fran useCard: Cancellation new against: fran.
	game player: rodri targetForRedoCancellationCardIs: Skip new.
	self
		should: [ game player: rodri useCard: Redo new against: fran ]
		raise: GameException
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'The target must be a Permanent Card' ]
]

{ #category : #tests }
GameSmalltalkersTest >> testReverseOrderOfPlayers [
	| speedUp wormHole effectSequence game |
	speedUp := SpeedUp new.
	wormHole := WormHole new.
	effectSequence := OrderedCollection new
		add: wormHole;
		add: wormHole;
		add: speedUp;
		yourself.
	game := self gamedWithDiceSequence: #(1 2 3 4) andEffectSequence: effectSequence.
	self assert: (game players at: 1) name equals: 'Rodri'.
	self assert: (game players at: 2) name equals: 'Fran'.
	game invertOrderOfPlayers.
	self assert: (game players at: 1) name equals: 'Fran'.
	self assert: (game players at: 2) name equals: 'Rodri'
]
