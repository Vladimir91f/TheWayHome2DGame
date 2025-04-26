extends PlayerState

func EnterState():
	Name = 'Fall'

func ExitState():
	pass
	
func Draw():
	pass

func Update(delta: float):
	Player.HandleGravity(delta, Player.GravityFall)
	Player.HorizontalMovement(Player.AirAcceleration, Player.AirDeceleration)
	Player.HandleLanding()
	Player.HandleJump()
	Player.HandleJumpBuffer()
	Player.HandleWallJump()
	Player.HandleWallSlide()
	HandleAnimation()

func HandleAnimation():
	Player.Animator.play('Fall')
	Player.HandleFlipH()
