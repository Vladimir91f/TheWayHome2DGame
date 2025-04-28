extends BaseState

func Enter():
	Name = 'Run'

func Exit():
	pass

func Update(_delta: float):
	FSM.Fall.Handle()
	FSM.Jump.Handle()
	FSMOwner.HorizontalMovement()
	FSM.Dash.Handle()
	HandleAnimation()
	HandleIdle()

func HandleIdle():
	if(FSMOwner.moveDirectionX == 0):
		FSM.ChangeState(FSM.Idle)
		
func HandleAnimation():
	FSMOwner.Animator.play('Run')
	FSMOwner.HandleFlipH()
