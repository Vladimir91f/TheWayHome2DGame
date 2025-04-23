extends PlayerState

func EnterState():
	Name = 'Run'

func ExitState():
	pass

func Update(_delta: float):
	Player.HandleFalling()
	Player.HandleJump()
	Player.HorizontalMovement()
	HandleAnimation()
	HandleIdle()

func HandleIdle():
	if(Player.moveDirectionX == 0):
		Player.ChangeState(States.Idle)
		
func HandleAnimation():
	Player.Animator.play('Run')
	Player.HandleFlipH()
