extends BaseState

func Enter():
	Name = 'Idle'

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta):
	FSMOwner.HorizontalMovement()
	FSM.Fall.Handle()
	FSM.Jump.Handle()
	FSM.Dash.Handle()
	if(FSMOwner.moveDirectionX != 0):
		FSM.ChangeState(FSM.Run)
	HandleAnimation()

func HandleAnimation():
	FSMOwner.Animator.play('Idle')
	FSMOwner.HandleFlipH()
