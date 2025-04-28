extends PlayerState

const WallMagnetSpeed = 50

func Enter():
	Name = 'WallSlide'
	if(Player.wallDirection == Vector2.LEFT):
		Player.velocity.x = -WallMagnetSpeed
	elif(Player.wallDirection == Vector2.RIGHT):
		Player.velocity.x = WallMagnetSpeed

func Exit():
	pass

func Update(_delta):
	Player.GetWallDirection()
	Player.HandleLanding()
	Player.HandleWallJump()
	HandleWallSlideMovement()
	HandleAnimation()

func HandleWallSlideMovement():
	if(Player.wallDirection == Vector2.ZERO or (!Player.keyLeft and !Player.keyRight)):
		Player.ChangeState(States.Fall)
	
	if((Player.wallDirection == Vector2.LEFT and Player.keyLeft)
		or (Player.wallDirection == Vector2.RIGHT and Player.keyRight)):
			if(!Player.keyJump):
				Player.velocity.y = Player.WallSlideSpeed
			else:
				Player.ChangeState(States.Fall)

func HandleAnimation():
	Player.Animator.play('WallSlide')
	Player.Sprite.flip_h = Player.wallDirection == Vector2.LEFT
