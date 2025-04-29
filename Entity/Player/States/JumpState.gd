extends BaseState

const JumpBufferTime = 0.15 # 0.15 - 9 кадров: FPS / желаемое кол-во кадров = время в секундах
const JumpVelocity = -240
const JumpMultiplier = 0.5
const MaxJumps = 1 # Если увеличить можно сделать двойные прыжки

var jumps = 0

func Enter():
	Name = 'Jump'
	FSMOwner.velocity.y = JumpVelocity

func Exit():
	pass

func Update(delta):
	FSMOwner.HandleGravity(delta)
	FSMOwner.HorizontalMovement()
	FSM.WallJump.Handle()
	FSM.Dash.Handle()
	HandleJumpToFall()
	HandleAnimation()

func Handle():
	if(FSMOwner.is_on_floor()):
		if(jumps < MaxJumps):
			if(FSMOwner.keyJumpPressed or FSMOwner.JumpBufferTimer.time_left > 0):
				FSMOwner.JumpBufferTimer.stop()
				jumps += 1
				FSM.ChangeState(FSM.Jump)
	else:
		# Обработка прыжка в воздухе, если первый прыжок уже был сделан с земли
		if(jumps < MaxJumps and jumps > 0 and FSMOwner.keyJumpPressed):
			jumps += 1
			FSM.ChangeState(FSM.Jump)
		# Обработка прыжка с таймером койота
		if(FSMOwner.CoyoteTimer.time_left > 0):
			if(FSMOwner.keyJumpPressed and jumps < MaxJumps):
				FSMOwner.CoyoteTimer.stop()
				jumps += 1
				FSM.ChangeState(FSM.Jump)

func HandleJumpBuffer():
	if(FSMOwner.keyJumpPressed):
		FSMOwner.JumpBufferTimer.start(JumpBufferTime)

func HandleJumpToFall():
	if(FSMOwner.velocity.y >= 0):
		FSM.ChangeState(FSM.JumpPeak)
	if(!FSMOwner.keyJump): # если игрок отпустил клавишу прыжка - уменьшить высоту прыжка
		FSMOwner.velocity.y *= JumpMultiplier
		FSM.ChangeState(FSM.Fall)
		
func HandleAnimation():
	FSMOwner.Animator.play('Jump')
	FSMOwner.HandleFlipH()
