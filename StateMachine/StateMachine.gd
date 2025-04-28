class_name StateMachine extends Node

# Pick this script to StateMachine node.

var States = null
var CurrentState: BaseState = null
var _previousState: BaseState = null
var _initialState: BaseState = null

# Initialize State Machine
func Initialize(fsmOwner: CharacterBody2D):
	if(fsmOwner == null):
		printerr('Owner not set.')
		return

	States = self.get_children()
	if(States == null or States.size() == 0):
		printerr('States not set.')
		return
		
	_initialState = States[0]
	if(_initialState == null):
		printerr('Initial State not set.')
		return
	
	for state in States:
		state.States = States
		state.FSMOwner = fsmOwner
		if(fsmOwner.FSM == null):
			printerr('Owner must have FSM!')
			return
		state.FSM = fsmOwner.FSM
		
	CurrentState = _initialState

func ChangeState(newState):
	if(newState != null):
		_previousState = CurrentState
		CurrentState = newState
		_previousState.Exit()
		CurrentState.Enter()
		return
