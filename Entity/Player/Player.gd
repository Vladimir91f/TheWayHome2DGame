extends CharacterBody2D

#region Player variables

# Nodes
@onready var Sprite = $Sprite
@onready var Collider = $Collider
@onready var Animator = $Animator

# Physics variables
const RunSpeed = 150
const Acceleration = 40
const Gravity = 300
const JumpVelocity = -150
const MaxJumps = 1

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

#endregion

func _physics_process(_delta: float) -> void:
	
	GetInputStates()
	
	HorizontalMovement()
	
	HandleAnimation()
	
	move_and_slide()

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	keyJumpPressed = Input.is_action_just_pressed("KeyJump")
	
	if(keyRight): facing = 1
	if(keyLeft): facing = -1

func HorizontalMovement():
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, Acceleration)
	
func HandleAnimation():
	Sprite.flip_h = facing < 0
	
# 36.28 (https://www.youtube.com/watch?v=STpems7xfe4&list=PLlOxT4J3Jmpxh5lRi5ugIdaXWJpZzAWj8&index=12)
	
