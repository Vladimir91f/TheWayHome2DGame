extends PlayerState

func Enter():
	Name = 'Idle'

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta):
	Player.HandleFalling()
	Player.HandleJump()
	Player.HorizontalMovement()
	if(Player.moveDirectionX != 0):
		Player.ChangeState(States.Run)
	Player.HandleDash()
	HandleAnimation()

func HandleAnimation():
	Player.Animator.play('Idle')
	Player.HandleFlipH()
