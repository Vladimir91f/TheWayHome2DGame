extends BaseState

@onready var DashBuffer: Timer = $"../../Timers/DashBuffer"
@onready var DashTimer: Timer = $"../../Timers/DashTimer"

@onready var DashGhost: CPUParticles2D = $"../../GraphicsEffects/Dash/DashGhost"

const DashSpeed = 300
const DashAcceleration = 4
const DashTime = 0.15
const DashDelayEffect = 30
const MaxDashes = 1
const DashSquish = 0.25
const DashBufferTime = 0.075
const DashMomentumCarry = 0.5

var dashes = 0
var squishX = 1.0
var squishY = 1.0
var squishStep = 0.02
var dashDirection: Vector2

var DistortionEffect = preload("res://Entity/Player/DashDistortion.tscn")

func Enter():
	Name = 'Dash'
	OS.delay_msec(DashDelayEffect)
	dashDirection = GetDashDirection()
	DashGhost.restart()
	FSMOwner.velocity = dashDirection.normalized() * DashSpeed
	DashTimer.start(DashTime)
	SetSquish(abs(dashDirection.y * DashSquish), abs(dashDirection.x * DashSquish))
	var _distortion = DistortionEffect.instantiate()
	_distortion.global_position = FSMOwner.global_position
	get_tree().root.get_node('World').add_child(_distortion)

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	UpdateSquish()
	HandleDashEnd()
	HandleAnimation()

func Handle():
	if(dashes < MaxDashes):
		if(FSMOwner.keyDash):
			if(DashTimer.time_left <= 0):
				DashTimer.start(DashBufferTime)
				await DashTimer.timeout
				dashes += 1
				FSM.ChangeState(FSM.Dash)

func HandleDashEnd():
	if(DashTimer.time_left <= 0):
		DashTimer.stop()
		FSMOwner.velocity *= DashMomentumCarry
		FSM.ChangeState(FSM.Fall)

func GetDashDirection() -> Vector2:
	var _dir = Vector2.ZERO
	if(!FSMOwner.keyLeft and !FSMOwner.keyRight and !FSMOwner.keyUp and !FSMOwner.keyDown):
		_dir = Vector2(FSMOwner.facing, 0)
	else:
		_dir = Vector2(Input.get_axis("KeyLeft", "KeyRight"), Input.get_axis("KeyUp", "KeyDown"))

	return _dir

func SetSquish(_squishX: float = 1.0, _squishY: float = 1.0, _squishStep: float = squishStep):
	squishX = _squishX if (_squishX != 0) else 1.0
	squishY = _squishY if (_squishY != 0) else 1.0
	squishStep = _squishStep if (_squishStep != 0) else squishStep

func UpdateSquish():
	FSMOwner.Sprite.scale.x = squishX
	FSMOwner.Sprite.scale.y = squishY	
	if(squishX != 1.0): squishX = move_toward(squishX, 1.0, squishStep)
	if(squishY != 1.0): squishY = move_toward(squishY, 1.0, squishStep)

func HandleAnimation():
	FSMOwner.Animator.play('Dash')
	FSMOwner.HandleFlipH()
