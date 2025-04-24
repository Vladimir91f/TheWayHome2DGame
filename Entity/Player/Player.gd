extends CharacterBody2D

#region Player variables

# Nodes
@onready var Sprite = $Sprite
@onready var Collider = $Collider
@onready var Animator = $Animator
@onready var Camera = $Camera
@onready var States = $StateMachine
@onready var JumpBufferTimer = $Timers/JumpBufferTimer
@onready var CoyoteTimer = $Timers/CoyoteTimer

@onready var RCBottomLeft = $Raycasts/WallJump/BottomLeft
@onready var RCBottomRight = $Raycasts/WallJump/BottomRight

# Physics variables
const RunSpeed = 120
const GroundAcceleration = 40 # Если сделать слишком маленьким, будет эффект скольжения, как на льду
const GroundDeceleration = 50
const AirAcceleration = 15
const AirDeceleration = 20

const GravityJump = 600
const GravityFall = 700
const MaxFallVelocity = 700
const JumpVelocity = -240
const JumpMultiplier = 0.5
const MaxJumps = 1 # Если увеличить можно сделать двойные прыжки
const CoyoteTime = 0.1 # 0.1 - 6 кадров: FPS / желаемое кол-во кадров = время в секундах
const JumpBufferTime = 0.15 # 0.15 - 9 кадров: FPS / желаемое кол-во кадров = время в секундах

const WallKickAcceleration = 4
const WallKickDeceleration = 5
const WallJumpYSpeedPeak = 0 # Скорость при которой прыжок от стены закончится и перейдет в состояние падения
const WallJumpVelocity = -190
const WallJumpHSpeed = 120

var moveSpeed = RunSpeed
var jumpSpeed = JumpVelocity
var Acceleration = GroundAcceleration
var Deceleration = GroundDeceleration
var moveDirectionX = 0
var jumps = 0
var wallDirection = Vector2.ZERO
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
	currentState.Update(delta)
	
	# Handle Movements
	HandleMaxFallVelocity()
	HorizontalMovement()
	HandleJump()
	
	# Commit movement
	move_and_slide()

func ChangeState(newState):
	if(newState != null):
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		return

#endregion

#region Custom functions

func HorizontalMovement(acceleration: float = Acceleration, deceleration: float = Deceleration):
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if(moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, acceleration)
	else: # Для плавной остановки игрока
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, deceleration)

func HandleFalling():
	if(!is_on_floor()):
		# Запускаем койот-таймер
		CoyoteTimer.start(CoyoteTime)
		ChangeState(States.Fall)

func HandleMaxFallVelocity():
	if(velocity.y > MaxFallVelocity): velocity.y = MaxFallVelocity

func HandleJumpBuffer():
	if(keyJumpPressed):
		JumpBufferTimer.start(JumpBufferTime)

func HandleLanding():
	if(is_on_floor()):
		jumps = 0
		ChangeState(States.Idle)

func HandleWallJump():
	GetWallDirection()
	if((keyJumpPressed or JumpBufferTimer.time_left > 0) and wallDirection != Vector2.ZERO):
		ChangeState(States.WallJump)

func GetWallDirection():
	if(RCBottomRight.is_colliding()):
		wallDirection = Vector2.RIGHT
	elif(RCBottomLeft.is_colliding()):
		wallDirection = Vector2.LEFT
	else:
		wallDirection = Vector2.ZERO

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	keyJumpPressed = Input.is_action_just_pressed("KeyJump")
	
	if(keyRight): facing = 1
	if(keyLeft): facing = -1

func HandleGravity(delta, gravity: float = GravityJump):
	if(!is_on_floor()):
		velocity.y += gravity * delta

func HandleJump():
	if(is_on_floor()):
		if(jumps < MaxJumps):
			if(keyJumpPressed or JumpBufferTimer.time_left > 0):
				JumpBufferTimer.stop()
				jumps += 1
				ChangeState(States.Jump)
	else:
		# Обработка прыжка в воздухе, если первый прыжок уже был сделан с земли
		if(jumps < MaxJumps and jumps > 0 and keyJumpPressed):
			jumps += 1
			ChangeState(States.Jump)
		# Обработка прыжка с таймером койота
		if(CoyoteTimer.time_left > 0):
			if(keyJumpPressed and jumps < MaxJumps):
				CoyoteTimer.stop()
				jumps += 1
				ChangeState(States.Jump)

func HandleFlipH():
	Sprite.flip_h = (facing < 1)

#endregion

# How to Code a PLATFORMER WALL CLIMB
# 00:00
