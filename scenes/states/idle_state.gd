extends State
class_name IdleState

@export var sprite: AnimatedSprite2D

func Enter():
	print("Entering idle state")
	sprite.play("idle")
	pass

func handle_input(event: InputEvent):
	if Input.is_action_pressed("moveleft") or Input.is_action_pressed("moveright"):
		state_machine.change_state("runstate")
		
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("jumpstate")
	pass
