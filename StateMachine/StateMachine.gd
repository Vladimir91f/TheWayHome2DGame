class_name StateMachine extends Node

# Pick this script to parent States node.

var States: Array[Node]
var CurrentState: BaseState = null
var previousState: BaseState = null
var initialState: BaseState = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initialize()

func SetStates(states: Array[Node]):
	States = states

func SetInitialState(_initialState: BaseState):
	initialState = _initialState

# Initialize State Machine
func Initialize():
	if(States == null or States.size() == 0):
		print('States not found! Please use SetStates() method.')
		return

	if(initialState == null):
		print('Initial State not found! Please use SetInitialState() method.')

	for state in self.get_children():
		state.States = States
		state.Owner = self

func ChangeState(newState):
	if(newState != null):
		previousState = CurrentState
		CurrentState = newState
		previousState.Exit()
		CurrentState.Enter()
		return
