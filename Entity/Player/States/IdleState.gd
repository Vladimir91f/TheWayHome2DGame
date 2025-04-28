extends BaseState

func Enter():
	Name = 'Idle'

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta):
	FSM.Fall.Handle()
	FSM.Jump.Handle()
	FSMOwner.HorizontalMovement()
	if(FSMOwner.moveDirectionX != 0):
		FSM.ChangeState(FSM.Run)
	FSM.Dash.Handle()
	HandleAnimation()

func HandleAnimation():
	FSMOwner.Animator.play('Idle')
	FSMOwner.HandleFlipH()
