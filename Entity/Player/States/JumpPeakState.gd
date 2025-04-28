extends BaseState

func Enter():
	Name = 'JumpPeak'

func Exit():
	pass
	
func Draw():
	pass

func Update(_delta: float):
	FSM.ChangeState(FSM.Fall)

func HandleAnimation():
	pass
