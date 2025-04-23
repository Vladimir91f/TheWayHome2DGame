extends PlayerState

func EnterState():
	Name = 'Idle'

func ExitState():
	pass
	
func Draw():
	pass

func Update(_delta):
	Player.HandleFalling()
	Player.HandleJump()
	Player.HorizontalMovement()
	if(Player.moveDirectionX != 0):
		Player.ChangeState(States.Run)
	HandleAnimation()

func HandleAnimation():
	Player.Animator.play('Idle')
	Player.HandleFlipH()
