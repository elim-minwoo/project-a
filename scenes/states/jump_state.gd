extends State
class_name JumpState

@export_category("Velocity Variables")
@export var player_speed: float = 330.0
@export var move_speed: float = 330.0

@export var sprite: AnimatedSprite2D

# jump
var jump_velocity: float = -500.0
var gravity

# timers (coyote)
var coyote_timer := 0.0
const COYOTE_TIME = 0.2

# timers (jump buffer)
var jump_buffer_timer := 0.0
const JUMP_BUFFER_TIME = 0.1

func enter():
	var character = state_machine.get_parent()

func physics_update(delta: float):
	var character = state_machine.get_parent()
	gravity = character.get_gravity().y
	character.velocity.y += gravity * delta
	
	var direction = Input.get_axis("moveleft", "moveright")
	character.velocity.x = direction * player_speed
	
	character.move_and_slide()
	
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("walkstate")
		else:
			state_machine.change_state("idlestate")
	
