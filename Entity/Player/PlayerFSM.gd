extends StateMachine

# States for Player FSM
@onready var Locked = $Locked
@onready var Idle = $Idle
@onready var Run = $Run
@onready var Jump = $Jump
@onready var JumpPeak = $JumpPeak
@onready var Fall = $Fall
@onready var WallJump = $WallJump
@onready var WallSlide = $WallSlide
@onready var Dash = $Dash
