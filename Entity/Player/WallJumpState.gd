extends PlayerState

var lastWallDirection
var shouldEnableWallKick

func EnterState():
	Name = 'WallJump'
	Player.velocity.y = Player.WallJumpVelocity
	lastWallDirection = Player.wallDirection
	ShouldOnlyJumpButtonWallKick(false)

func ExitState():
	pass

func Update(delta):
	Player.GetWallDirection()
	Player.HandleGravity(delta, Player.GravityJump)
	HandleWallKickMovement()
	HandleWallJumpEnd()
	Player.HandleDash()
	HandleAnimation()

func ShouldOnlyJumpButtonWallKick(shouldEnable: bool):
	shouldEnableWallKick = shouldEnable
	var jumpVelocityX = Player.WallJumpHSpeed * Player.wallDirection.x * -1
	if(shouldEnable):
		if(Player.keyLeft or Player.keyRight):
			Player.velocity.x = jumpVelocityX
		else:
			if(Player.jumps == Player.MaxJumps):
				Player.velocity.x = jumpVelocityX
			else:
				Player.ChangeState(States.Fall)
	else:
		Player.velocity.x = jumpVelocityX

func HandleWallKickMovement():
	if(!Player.keyLeft and !Player.keyRight):
		Player.velocity.x = move_toward(Player.velocity.x, 0, Player.WallKickAcceleration) 
	else:
		if((lastWallDirection == Vector2.LEFT and Player.keyRight) or (lastWallDirection == Vector2.RIGHT and Player.keyLeft)):
			Player.HorizontalMovement(Player.WallKickAcceleration, Player.WallKickDeceleration)

func HandleWallJumpEnd():
	if(Player.velocity.y >= Player.WallJumpYSpeedPeak):
		Player.ChangeState(States.Fall)
		
	if(Player.wallDirection != lastWallDirection and Player.wallDirection != Vector2.ZERO):
		Player.ChangeState(States.Fall)
		

func HandleAnimation():
	if(!Player.keyLeft and !Player.keyRight and shouldEnableWallKick):
		Player.Animator.play('WallKick')
		Player.Sprite.flip_h = Player.velocity.x > 0
	else:
		Player.Animator.play('WallJump')
		Player.Sprite.flip_h = Player.velocity.x < 0
