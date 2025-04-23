extends PlayerState

func EnterState():
	Name = 'Fall'

func ExitState():
	pass
	
func Draw():
	pass

func Update(delta: float):
	Player.HandleGravity(delta)
	Player.HorizontalMovement()
	Player.HandleLanding()
	HandleAnimation()

func HandleAnimation():
	Player.Animator.play('Fall')
	Player.HandleFlipH()
