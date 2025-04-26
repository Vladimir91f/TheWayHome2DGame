extends PlayerState

const WallMagnetSpeed = 50

func EnterState():
	Name = 'WallGrab'
	Player.velocity = Vector2.ZERO
	
	if(Player.wallClimbDirection == Vector2.LEFT):
		Player.velocity.x = -WallMagnetSpeed
	elif(Player.wallClimbDirection == Vector2.RIGHT):
		Player.velocity.x = WallMagnetSpeed

func ExitState():
	pass

func Update(_delta: float):
	Player.HanleWallRelease()
	#HandleClimb()
	Player.climbStamina -= Player.GrabStaminaCost
	Player.HandleWallJump()
	HandleAnimation()
	
func HandleClimb():
	if(Player.keyUp or Player.keyDown):
		Player.ChangeState(States.WallClimb)

func HandleAnimation():
	Player.Animator.play('WallGrab')
	Player.Sprite.flip_h = (Player.wallClimbDirection == Vector2.LEFT)
