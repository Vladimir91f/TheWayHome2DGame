extends PlayerState

func Enter():
	Name = 'Jump'
	Player.velocity.y = Player.jumpSpeed

func Exit():
	pass

func Update(delta):
	Player.HandleGravity(delta)
	Player.HorizontalMovement()
	Player.HandleWallJump()
	Player.HandleDash()
	HandleJumpToFall()
	HandleAnimation()

func HandleJumpToFall():
	if(Player.velocity.y >= 0):
		Player.ChangeState(States.JumpPeak)
	if(!Player.keyJump): # если игрок отпустил клавишу прыжка - уменьшить высоту прыжка
		Player.velocity.y *= Player.JumpMultiplier
		Player.ChangeState(States.Fall)
		
func HandleAnimation():
	Player.Animator.play('Jump')
	Player.HandleFlipH()
