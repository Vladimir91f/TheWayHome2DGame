extends CharacterBody2D

#region Player variables

# Nodes
@onready var Sprite = $Sprite
@onready var Collider = $Collider
@onready var Animator = $Animator
@onready var Camera = $Camera
@onready var States = $StateMachine

# Physics variables
const RunSpeed = 150
const Acceleration = 30 #если сделать слишком маленьким, будет эффект скольжения, как на льду
const Deceleration = 25
const Gravity = 300
const JumpVelocity = -150
const MaxJumps = 1 #если увеличить можно сделать двойные прыжки

var moveSpeed = RunSpeed
var moveDirectionX = 0
var jumps = 0
var facing = 1

# Input variables
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpPressed = false

# State Machine
var currentState = null
var previousState = null

#endregion

#region Main Loop functions

func _ready() -> void:
	# Initialize State Machine
	for state in States.get_children():
		state.States = States
		state.Player = self
	previousState = States.Fall
	currentState = States.Fall

func _draw() -> void:
	currentState.Draw()

func _physics_process(delta: float) -> void:
	# Get input states
	GetInputStates()
	
	# Update State
	currentState.Update()
	
	# Handle Movements
	HandleGravity(delta)
	HorizontalMovement()
	HandleJump()
	
	# Commit movement
	move_and_slide()
	
	# Handle animation
	HandleAnimation()

func ChangeState(newState):
	if(newState != null):
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		print('Change State from: ' + previousState.Name + ' to: ' + currentState.Name)

#endregion

#region Custom functions

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	keyJumpPressed = Input.is_action_just_pressed("KeyJump")
	
	if(keyRight): facing = 1
	if(keyLeft): facing = -1

func HorizontalMovement(acceleration: float = Acceleration, deceleration: float = Deceleration):
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if(moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, acceleration)
	else: #для плавной остановки игрока
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, deceleration)

func HandleFalliing():
	if(!is_on_floor()):
		ChangeState(States.Fall)

func HandleLanding():
	if(is_on_floor()):
		jumps = 0
		ChangeState(States.Idle)

func HandleGravity(delta, gravity: float = Gravity):
	if(!is_on_floor()):
		velocity.y += gravity * delta

func HandleJump():
	if((keyJumpPressed) and (jumps < MaxJumps)):
		velocity.y = JumpVelocity
		jumps += 1

func HandleAnimation():
	Sprite.flip_h = (facing < 0)
	
	if(is_on_floor()):
		if(velocity.x != 0):
			Animator.play('Run')
		else:
			Animator.play('Idle')
	else:
		if(velocity.y < 0):
			Animator.play('Jump')
		else:
			Animator.play('Fall')
	
#endregion

# 23:52 (https://www.youtube.com/watch?v=ECAeiRHxCD0&list=PLlOxT4J3Jmpxh5lRi5ugIdaXWJpZzAWj8&index=11)
