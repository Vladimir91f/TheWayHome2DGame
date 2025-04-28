extends BaseState

const WallJumpVelocity = -190
const WallJumpHSpeed = 120

var lastWallDirection
var shouldEnableWallKick

func Enter():
	Name = 'WallJump'
	FSMOwner.velocity.y = WallJumpVelocity
	lastWallDirection = FSMOwner.wallDirection
	ShouldOnlyJumpButtonWallKick(false)

func Exit():
	pass

func Update(delta):
	FSMOwner.GetWallDirection()
	FSMOwner.HandleGravity(delta, FSMOwner.GravityJump)
	HandleWallKickMovement()
	HandleWallJumpEnd()
	FSM.Dash.Handle()
	HandleAnimation()

func Handle():
	FSMOwner.GetWallDirection()
	if((FSMOwner.keyJumpPressed or FSMOwner.JumpBufferTimer.time_left > 0) and FSMOwner.wallDirection != Vector2.ZERO):
		FSM.ChangeState(FSM.WallJump)

func ShouldOnlyJumpButtonWallKick(shouldEnable: bool):
	shouldEnableWallKick = shouldEnable
	var jumpVelocityX = WallJumpHSpeed * FSMOwner.wallDirection.x * -1
	if(shouldEnable):
		if(FSMOwner.keyLeft or FSMOwner.keyRight):
			FSMOwner.velocity.x = jumpVelocityX
		else:
			if(FSMOwner.jumps == FSMOwner.MaxJumps):
				FSMOwner.velocity.x = jumpVelocityX
			else:
				FSM.ChangeState(FSM.Fall)
	else:
		FSMOwner.velocity.x = jumpVelocityX

func HandleWallKickMovement():
	if(!FSMOwner.keyLeft and !FSMOwner.keyRight):
		FSMOwner.velocity.x = move_toward(FSMOwner.velocity.x, 0, FSMOwner.WallKickAcceleration) 
	else:
		if((lastWallDirection == Vector2.LEFT and FSMOwner.keyRight) or (lastWallDirection == Vector2.RIGHT and FSMOwner.keyLeft)):
			FSMOwner.HorizontalMovement(FSMOwner.WallKickAcceleration, FSMOwner.WallKickDeceleration)

func HandleWallJumpEnd():
	if(FSMOwner.velocity.y >= FSMOwner.WallJumpYSpeedPeak):
		FSM.ChangeState(FSM.Fall)
		
	if(FSMOwner.wallDirection != lastWallDirection and FSMOwner.wallDirection != Vector2.ZERO):
		FSM.ChangeState(FSM.Fall)
		

func HandleAnimation():
	if(!FSMOwner.keyLeft and !FSMOwner.keyRight and shouldEnableWallKick):
		FSMOwner.Animator.play('WallKick')
		FSMOwner.Sprite.flip_h = FSMOwner.velocity.x > 0
	else:
		FSMOwner.Animator.play('WallJump')
		FSMOwner.Sprite.flip_h = FSMOwner.velocity.x < 0
