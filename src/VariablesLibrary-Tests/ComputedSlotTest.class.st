Class {
	#name : 'ComputedSlotTest',
	#superclass : 'SlotSilentTest',
	#category : 'VariablesLibrary-Tests-Tests',
	#package : 'VariablesLibrary-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
ComputedSlotTest >> testHasSameDefinitionAs [
	| slot1 slot2 slot3 |
	<ignoreNotImplementedSelectors: #(slot1 slot2)>

	slot1 := #slot1 => ComputedSlot with: [ :obj | 3 + 2 ].
	slot2 := #slot2 => ComputedSlot with: [ :obj | 1 + 2 ].
	slot3 := #slot2 => ComputedSlot with: [ :obj | 1 + 2 ].

	self deny: (slot1 hasSameDefinitionAs: slot2).
	self assert: (slot2 hasSameDefinitionAs: slot3)
]

{ #category : 'tests' }
ComputedSlotTest >> testReadComputedSlotCompiled [
	| object slot |
	<ignoreNotImplementedSelectors: #(slot1)>

	slot := #slot1 => ComputedSlot with: [:obj | 3 + 2 ].
	aClass := self make: [ :builder | builder slots: {slot} ].
	self assert: (aClass hasSlotNamed: #slot1).

	object := aClass new.

	"The slot is virtual and does not use memory"
	self assert: object basicSize  equals: 0.

	"now compile an accessor and read"
	self compileAccessorsFor: slot.
	self assert: object slot1 equals: 5
]

{ #category : 'tests' }
ComputedSlotTest >> testReadComputedSlotReflective [
	| slot object |
	slot := #slot1 => ComputedSlot with: [:obj | 3 + 2 ].
	aClass := self make: [ :builder | builder slots: {slot} ].
	self assert: (aClass hasSlotNamed: #slot1).
	object := aClass new.

	self assert: (slot read: object) equals: 5
]

{ #category : 'tests' }
ComputedSlotTest >> testReadComputedSlotReflectiveNoArg [
	| slot object |
	slot := #slot1 => ComputedSlot with: [3 + 2 ].
	aClass := self make: [ :builder | builder slots: {slot} ].
	self assert: (aClass hasSlotNamed: #slot1).

	object := aClass new.

	self assert: (slot read: object) equals: 5
]

{ #category : 'tests' }
ComputedSlotTest >> testWriteComputedSlotCompiled [
	| slot object |
	<ignoreNotImplementedSelectors: #(slot1: slot1)>
	slot := #slot1 => ComputedSlot with: [:obj | 3 + 2 ].
	aClass := self make: [ :builder | builder slots: {slot} ].
	self assert: (aClass hasSlotNamed: #slot1).

	object := aClass new.

	"now compile an accessor and write"
	self compileAccessorsFor: slot.
	object slot1: 10.
	"the write is ignored"
	self assert: object slot1 equals: 5
]
