extends PlayerState

const DashSquish = 0.25
var DistortionEffect = preload("res://Entity/Player/DashDistortion.tscn")

func EnterState():
	Name = 'Dash'
	OS.delay_msec(Player.DashDelayEffect)
	Player.dashDirection = Player.GetDashDirection()
	Player.DashGhost.restart()
	Player.velocity = Player.dashDirection.normalized() * Player.DashSpeed
	Player.DashTimer.start(Player.DashTime)
	Player.SetSquish(abs(Player.dashDirection.y * DashSquish), abs(Player.dashDirection.x * DashSquish))
	var _distortion = DistortionEffect.instantiate()
	_distortion.global_position = Player.global_position
	get_tree().root.get_node('World').add_child(_distortion)
	#Player.Animator.play('Dash')
	#Player.HandleFlipH()

func ExitState():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	HandleDashEnd()
	HandleAnimation()

func HandleDashEnd():
	if(Player.DashTimer.time_left <= 0):
		Player.DashTimer.stop()
		Player.velocity *= Player.DashMomentumCarry
		Player.ChangeState(States.Fall)

func HandleAnimation():
	Player.Animator.play('Dash')
	Player.HandleFlipH()
