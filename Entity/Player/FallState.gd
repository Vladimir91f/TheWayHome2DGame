extends PlayerState

func EnterState():
	Name = 'Fall'

func ExitState():
	pass
	
func Draw():
	pass

func Update(delta: float):
	Player.HandleGravity(delta, Player.GravityFall)
	Player.HorizontalMovement()
	Player.HandleLanding()
	Player.HandleJump()
	Player.HandleJumpBuffer()
	HandleAnimation()

func HandleAnimation():
	Player.Animator.play('Fall')
	Player.HandleFlipH()
