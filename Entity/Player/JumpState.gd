extends PlayerState

func EnterState():
	Name = 'Jump'
	Player.velocity.y = Player.jumpSpeed

func ExitState():
	pass
	
func Draw():
	pass

func Update(delta):
	Player.HandleGravity(delta)
	Player.HorizontalMovement()
	HandleJumpToFall()
	HandleAnimation()

func HandleJumpToFall():
	if(Player.velocity.y >= 0):
		Player.ChangeState(States.JumpPeak)
		
func HandleAnimation():
	Player.Animator.play('Jump')
	Player.HandleFlipH()
