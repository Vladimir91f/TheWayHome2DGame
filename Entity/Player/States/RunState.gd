extends PlayerState

func Enter():
	Name = 'Run'

func Exit():
	pass

func Update(_delta: float):
	Player.HandleFalling()
	Player.HandleJump()
	Player.HorizontalMovement()
	Player.HandleDash()
	HandleAnimation()
	HandleIdle()

func HandleIdle():
	if(Player.moveDirectionX == 0):
		Player.ChangeState(States.Idle)
		
func HandleAnimation():
	Player.Animator.play('Run')
	Player.HandleFlipH()
