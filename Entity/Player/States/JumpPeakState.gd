extends PlayerState

func Enter():
	Name = 'JumpPeak'

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	Player.ChangeState(States.Fall)

func HandleAnimation():
	pass
