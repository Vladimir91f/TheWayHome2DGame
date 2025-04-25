extends PlayerState

func EnterState():
	Name = 'WallClimb'
	Player.velocity.y = Player.jumpSpeed

func ExitState():
	pass
	
func Update(_delta):
	Player.GetCanWallClimb()
	Player.climbStamina -= Player.ClimbStaminaCost
	HandleClimbMovement()
	Player.HandleWallRelease()
	Player.HandleWallJump()
	HandleAnimation()
	
func HandleClimbMovement():
	if(Player.keyClimb):
		if(Player.wallClimbDirection != Vector2.ZERO):
			if(Player.keyUp and (Player.RCWallClimbLimitTopLeft.is_colliding() or Player.RCWallClimbLimitTopRight.is_colliding())):
				Player.velocity.y = -Player.ClimbSpeed
			elif(Player.keyDown and (Player.RCWallClimbLimitBottomLeft.is_colliding() or Player.RCWallClimbLimitBottomRight.is_colliding())):
				Player.velocity.y = Player.ClimbSpeed
			else:
				Player.ChangeState(States.WallGrab)
	else:
		Player.ChangeState(States.Fall)
		
func HandleAnimation():
	if(Player.velocity.y > 0):
		Player.Animator.speed_scale = -1
	else:
		Player.Animator.speed_scale = 1
	Player.Animator.play('WallClimb')
	Player.Sprite.flip_h = Player.wallDirection == Vector2.LEFT
