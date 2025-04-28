extends BaseState

const WallMagnetSpeed = 50
const WallSlideSpeed = 40

func Enter():
	Name = 'WallSlide'
	if(FSMOwner.wallDirection == Vector2.LEFT):
		FSMOwner.velocity.x = -WallMagnetSpeed
	elif(FSMOwner.wallDirection == Vector2.RIGHT):
		FSMOwner.velocity.x = WallMagnetSpeed

func Exit():
	pass

func Update(_delta):
	FSMOwner.GetWallDirection()
	FSMOwner.HandleLanding()
	FSM.WallJump.Handle()
	HandleWallSlideMovement()
	HandleAnimation()

func Handle():
	if((FSMOwner.wallDirection == Vector2.LEFT and FSMOwner.keyLeft and FSMOwner.RCWallKickLeft.is_colliding())
		or (FSMOwner.wallDirection == Vector2.RIGHT and FSMOwner.keyRight and FSMOwner.RCWallKickRight.is_colliding())):
			if(!FSMOwner.keyJump):
				FSM.ChangeState(FSM.WallSlide)

func HandleWallSlideMovement():
	if(FSMOwner.wallDirection == Vector2.ZERO or (!FSMOwner.keyLeft and !FSMOwner.keyRight)):
		FSM.ChangeState(FSM.Fall)
	
	if((FSMOwner.wallDirection == Vector2.LEFT and FSMOwner.keyLeft)
		or (FSMOwner.wallDirection == Vector2.RIGHT and FSMOwner.keyRight)):
			if(!FSMOwner.keyJump):
				FSMOwner.velocity.y = WallSlideSpeed
			else:
				FSM.ChangeState(FSM.Fall)

func HandleAnimation():
	FSMOwner.Animator.play('WallSlide')
	FSMOwner.Sprite.flip_h = FSMOwner.wallDirection == Vector2.LEFT
