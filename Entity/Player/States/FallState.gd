extends BaseState

const CoyoteTime = 0.1 # 0.1 - 6 кадров: FPS / желаемое кол-во кадров = время в секундах

func Enter():
	Name = 'Fall'

func Exit():
	pass
	
func Draw():
	pass

func Update(delta: float):
	FSMOwner.HandleGravity(delta, FSMOwner.GravityFall)
	FSMOwner.HorizontalMovement(FSMOwner.AirAcceleration, FSMOwner.AirDeceleration)
	FSMOwner.HandleLanding()
	FSM.Jump.Handle()
	FSM.Jump.HandleJumpBuffer()
	FSM.WallJump.Handle()
	FSM.WallSlide.Handle()
	FSM.Dash.Handle()
	HandleAnimation()

func Handle():
	if(!FSMOwner.is_on_floor()):
		# Запускаем койот-таймер
		FSMOwner.CoyoteTimer.start(CoyoteTime)
		FSM.ChangeState(FSM.Fall)

func HandleAnimation():
	FSMOwner.Animator.play('Fall')
	FSMOwner.HandleFlipH()
