extends BaseState

const MaxDashes = 1
const DashSquish = 0.25
const DashBufferTime = 0.075
const DashMomentumCarry = 0.5
var dashes = 0
var DistortionEffect = preload("res://Entity/Player/DashDistortion.tscn")

func Enter():
	Name = 'Dash'
	OS.delay_msec(FSMOwner.DashDelayEffect)
	FSMOwner.dashDirection = FSMOwner.GetDashDirection()
	FSMOwner.DashGhost.restart()
	FSMOwner.velocity = FSMOwner.dashDirection.normalized() * FSMOwner.DashSpeed
	FSMOwner.DashTimer.start(FSMOwner.DashTime)
	FSMOwner.SetSquish(abs(FSMOwner.dashDirection.y * DashSquish), abs(FSMOwner.dashDirection.x * DashSquish))
	var _distortion = DistortionEffect.instantiate()
	_distortion.global_position = FSMOwner.global_position
	get_tree().root.get_node('World').add_child(_distortion)

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	HandleDashEnd()
	HandleAnimation()

func Handle():
	if(dashes < MaxDashes):
		if(FSMOwner.keyDash):
			if(FSMOwner.DashTimer.time_left <= 0):
				FSMOwner.DashTimer.start(DashBufferTime)
				await FSMOwner.DashTimer.timeout
				dashes += 1
				FSM.ChangeState(FSM.Dash)

func HandleDashEnd():
	if(FSMOwner.DashTimer.time_left <= 0):
		FSMOwner.DashTimer.stop()
		FSMOwner.velocity *= DashMomentumCarry
		FSM.ChangeState(FSM.Fall)

func HandleAnimation():
	FSMOwner.Animator.play('Dash')
	FSMOwner.HandleFlipH()
