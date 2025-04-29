extends CharacterBody2D

#region Player variables

# Nodes
@onready var Sprite = $Sprite
@onready var Collider = $Collider
@onready var Animator = $Animator
@onready var Camera = $Camera

@onready var FSM = $StateMachine

@onready var JumpBufferTimer = $Timers/JumpBufferTimer
@onready var CoyoteTimer = $Timers/CoyoteTimer

@onready var RCWallKickLeft = $Raycasts/WallJump/WallKickLeft
@onready var RCWallKickRight = $Raycasts/WallJump/WallKickRight


# Physics variables
const RunSpeed = 120
const GroundAcceleration = 40 # Если сделать слишком маленьким, будет эффект скольжения, как на льду
const GroundDeceleration = 50
const AirAcceleration = 15
const AirDeceleration = 20

const GravityJump = 600
const GravityFall = 700
const MaxFallVelocity = 700

# Player variables
var moveSpeed = RunSpeed
var Acceleration = GroundAcceleration
var Deceleration = GroundDeceleration
var moveDirectionX = 0
var wallDirection = Vector2.ZERO

var facing = 1

# Input variables
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpPressed = false
var keyDash = false

#endregion

#region Main Loop functions

func _ready() -> void:
	FSM.Initialize(self)

func _draw() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Get input states
	GetInputStates()
	
	# Update State
	FSM.CurrentState.Update(delta)
	
	# Handle Movements
	HandleMaxFallVelocity()
	HorizontalMovement()
	
	# Commit movement
	move_and_slide()
	
	# Update Squish
	FSM.Dash.UpdateSquish()

#endregion

#region Custom functions

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	keyJumpPressed = Input.is_action_just_pressed("KeyJump")
	keyDash = Input.is_action_just_pressed("KeyDash")
	
	if(keyRight): facing = 1
	if(keyLeft): facing = -1

func HorizontalMovement(acceleration: float = Acceleration, deceleration: float = Deceleration):
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if(moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, acceleration)
	else: # Для плавной остановки игрока
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, deceleration)

func HandleMaxFallVelocity():
	if(velocity.y > MaxFallVelocity): velocity.y = MaxFallVelocity

func HandleLanding():
	if(is_on_floor()):
		FSM.Jump.jumps = 0
		FSM.Dash.dashes = 0
		FSM.ChangeState(FSM.Idle)

func HandleGravity(delta, gravity: float = GravityJump):
	if(!is_on_floor()):
		velocity.y += gravity * delta

func HandleFlipH():
	Sprite.flip_h = (facing < 1)

#endregion

# ShaderMaterials!!! - https://godotshaders.com/
# How to Code a PLATFORMER WALL CLIMB
# 00:00
