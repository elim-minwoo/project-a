extends State
class_name RunState

@export_category("Velocity Variables")
@export var player_speed: float = 330.0
@export var move_speed: float = 330.0

@export var sprite: AnimatedSprite2D

func physics_update(delta: float):
	var character = state_machine.get_parent()
	var direction = Input.get_axis("moveleft", "moveright")
	
	if direction == 0:
		state_machine.change_state("idlestate")
		return
		
	character.velocity.x = direction * player_speed
	character.move_and_slide()

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
