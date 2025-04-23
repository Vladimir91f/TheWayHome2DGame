extends PlayerState

func EnterState():
	Name = 'JumpPeak'

func ExitState():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	Player.ChangeState(States.Fall)

func HandleAnimation():
	pass
