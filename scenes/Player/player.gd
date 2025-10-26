extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $PlayerSprite
@onready var player_anim = get_node("PlayerAnim")
@onready var sprite_trail: Node = $SpriteTrail
@onready var dash: Node2D = $Dash	

#region variables
var jump_velocity: float = -500.0
var gravity

# direction
var direction = Input.get_axis("moveleft", "moveright")
var look_dir_x: int = 1

# timers
var coyote_timer := 0.0
const COYOTE_TIME = 0.2

var jump_buffer_timer := 0.0
const JUMP_BUFFER_TIME = 0.1

var wall_jump_timer := 0.0
const WALL_JUMP_TIME := 0.2

# dash variables
var dash_speed = 2000.0
var dash_duration = 0.1
var bullet_time = true
var can_dash = true
#endregion

#region export variables
@export_category("Velocity Variables")
@export var player_speed: float = 330.0
@export var move_speed: float = 330.0

@export_category("Wall Logic Variables")
@export var wall_x_force =  300.0
@export var wall_y_force = 1200.0
@export var wall_slide_speed: float = 30.0

# state variables
@export var is_attacking := false
@export var is_parrying := false
@export var is_jumping := false
@export var is_wall_jumping := false
#endregion



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_tp"):
		global_position = Vector2(0, 0)
	
	# dash
	if Input.is_action_just_pressed("dash") && dash.can_dash && !dash.is_dashing():
		dash.start_dash(dash_duration)
		if not bullet_time:
			sprite_trail.activate_trail()
		
	player_speed = dash_speed if dash.is_dashing() else move_speed



func _physics_process(delta: float) -> void: 
	
	direction = Input.get_axis("moveleft", "moveright")
	
	# gravity
	gravity = get_gravity().y
	velocity.y += gravity * delta
	
	var on_wall = is_on_wall_only() and not direction == 0
	
	
	#region movement
	# handle movement
	if not is_wall_jumping:
		velocity.x = direction * player_speed
	else:
		if abs(velocity.x) < player_speed:
			velocity.x += direction * player_speed * 0.09
	
	
	
	# handle jump
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
		velocity.y = jump_velocity
		is_jumping = true
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		
	# jump cut
	if Input.is_action_just_released("moveup") and is_jumping and velocity.y < 0:
		velocity.y *= 0.3

	# set max falling speed
	var max_fall_speed: float = 1000.0
	velocity.y = clamp(velocity.y, float(-INF), max_fall_speed)
	#endregion
	
	
	# input buffer timer
	coyote_timer = max(coyote_timer - delta, 0)
	jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	else:
		is_wall_jumping = false
	
	# jump buffer
	if Input.is_action_just_pressed("moveup"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	
	## state machine??
	if on_wall:
		wall_process()
	elif is_on_floor():
		coyote_timer = COYOTE_TIME # coyote time
		floor_process()
	#else:
		#air_process(delta)
	
	manage_abilities()
	update_animations()
	move_and_slide()



#region manage process when on floor, wall, and air
func floor_process():
	if not is_on_floor():
		return
		
	if velocity.y == 0:
		is_jumping = false
	is_wall_jumping = false
	
	if Input.is_action_just_pressed("moveup"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		
	if Input.is_action_just_pressed("parry"):
		parry()



func wall_process():
	if velocity.y <= wall_slide_speed:
		return

	if velocity.x == 0:
		is_wall_jumping = false
	
	# wall slide
	if not is_wall_jumping:
		velocity.y =  lerp(velocity.y, wall_slide_speed, 0.3)
		
	# wall jump
	if Input.is_action_just_pressed("moveup"):
		is_jumping = true
		is_wall_jumping = true
		wall_jump_timer = WALL_JUMP_TIME
		
		var wall_dir = get_wall_normal().x
		velocity.x = wall_dir * wall_x_force
		velocity.y  = jump_velocity



@warning_ignore("unused_parameter")
func air_process(delta: float):
	
	is_jumping = false
	is_wall_jumping = false

#endregion



func manage_abilities():
	# bullet time ability
	if Input.is_action_pressed("timeslow"):
		Engine.time_scale = 0.3 # must change laawater
		sprite_trail.activate_trail()
		bullet_time = true
	else:
		Engine.time_scale = 1.0
		bullet_time = false

func parry():
	is_parrying = true
	player_anim.play("parry")



@warning_ignore("shadowed_variable")
func manage_flip(direction):
	if direction == 0:
		return
	
	# flip sprite
	if direction == -1.0:
		sprite_2d.flip_h = true
	elif direction == 1.0:
		sprite_2d.flip_h = false
	
	if is_on_wall_only():
		sprite_2d.flip_h = not sprite_2d.flip_h



func update_animations():
	manage_flip(Input.get_axis("moveleft", "moveright"))
	
	if not is_attacking and not is_parrying:
		if is_on_wall_only() and not direction == 0:
		#wall jump anim
			player_anim.play("wall")
			
		# jump anim
		elif velocity.y < 0 and is_jumping:
			player_anim.play("jump")
			
		# fall anim
		elif velocity.y > 0 and not is_on_floor():
			player_anim.play("fall")
			
		# run anim
		elif velocity.x != 0 and is_on_floor():
			player_anim.play("run")
			
		# idle anim
		else:
			player_anim.play("idle")
			
