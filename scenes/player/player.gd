extends CharacterBody2D

@onready var debug_label: Label = $Label

# refer nodes
@onready var sprite: AnimatedSprite2D = $PlayerSprite
@onready var player_anim = get_node("PlayerAnim")
@onready var player_hitbox: CollisionShape2D = $PlayerHitbox
@onready var parry_hitbox: CollisionShape2D = $Parry/ParryHitbox
@onready var stamina_ui: Control = $TimeSlowBar

@onready var player_audio: AudioStreamPlayer = $PlayerAudio
@onready var audio_manage: Node = $AudioManage

# refer abilities
@onready var dash: Node2D = $Dash

# manual signals
signal wall_touching # manual signal for wall touch





#region variables
# jump
var jump_velocity: float = -500.0
var gravity

# direction
var direction = Input.get_axis("moveleft", "moveright")

# timers (coyote)
var coyote_timer := 0.0
const COYOTE_TIME = 0.2

# timers (jump buffer)
var jump_buffer_timer := 0.0
const JUMP_BUFFER_TIME = 0.1

# timers (wall jumps)
var wall_jump_timer := 0.0
const WALL_JUMP_TIME := 0.2

# state variables
var on_wall = false
var is_wall_sliding = false

# ability variables
var is_dashing := false
var can_dash = true
var has_dashed = false
var dash_dir := 0

# state variables
var is_attacking := false
var is_parrying := false
var is_jumping := false
var is_wall_jumping := false
#endregion





#region export variables
@export_category("Velocity Variables")
@export var player_speed: float = 330.0
@export var move_speed: float = 330.0

@export_category("Wall Logic Variables")
@export var wall_x_force =  300.0
@export var wall_y_force = 1200.0
@export var wall_slide_speed: float = 30.0

@export_category("Wall Logic Variables")
@export var dash_speed := 2000.0
@export var dash_duration := 0.1
#endregion





func _process(_delta: float) -> void: # load all the time
	# debug tp to spawn
	if Input.is_action_just_pressed("debug_tp"): # backslash
		global_position = Vector2(0, 0)





#region physics and movement
func _physics_process(delta: float) -> void: # loads every physics tick
	
	if is_on_wall(): # emit signal when wall touched
		wall_touching.emit()
	
	
	# player direction (from left right input)
	direction = Input.get_axis("moveleft", "moveright")
	if direction != 0:
		Global.player_dir = int(direction)
	
	# get and apply gravity
	gravity = get_gravity().y
	velocity.y += gravity * delta
	
	# recognise if on wall
	on_wall = is_on_wall_only() and not direction == 0
	
	
	## state machine
	if on_wall:
		wall_process()
	elif is_on_floor():
		coyote_timer = COYOTE_TIME # coyote time
		floor_process()





	#region movement
	# handle movement
	if dash.is_dashing(): # if dashing, do not change direction
		velocity.x = dash_dir * dash_speed
	elif not is_wall_jumping: # if not wall jumping, move left and right by player direction
		velocity.x = direction * player_speed
	else:
		if abs(velocity.x) < player_speed:
			velocity.x += direction * player_speed * 0.09


	# handle jump
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
		coyote_timer = 0.0
		velocity.y = jump_velocity
		is_jumping = true
		jump_buffer_timer = 0.0


	# jump cut
	if Input.is_action_just_released("jump") and is_jumping and velocity.y < 0:
		velocity.y *= 0.3


	# set max falling speed
	var max_fall_speed: float = 1000.0
	velocity.y = clamp(velocity.y, float(-INF), max_fall_speed)


	manage_buffer(delta)
	manage_abilities()
	
	update_animations()
	move_and_slide()



func manage_buffer(delta):
	# coyote and jump buffer timer
	coyote_timer = max(coyote_timer - delta, 0)
	jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	else:
		is_wall_jumping = false
	
	# jump buffer reset
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
#endregion





#region state functions
func floor_process():
	
	if not is_on_floor():
		return
	
	# if on floor and not moving up, not jumping or wall jumping
	if velocity.y == 0:
		is_jumping = false
		is_wall_jumping = false
	
	# reset jump buffer only when on floor
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	# only allow parry when on floor
	if Input.is_action_just_pressed("parry"):
		parry()



func wall_process():
	
	if velocity.y <= wall_slide_speed:
		return
		
	# if on wall but not moving towards wall, wall jump is canceled
	if velocity.x == 0:
		is_wall_jumping = false
	
	
	# wall slide
	if not is_wall_jumping:
		velocity.y =  lerp(velocity.y, wall_slide_speed, 0.3)
	
	
	# wall jump
	if Input.is_action_just_pressed("jump"):
		is_jumping = true
		is_wall_jumping = true
		wall_jump_timer = WALL_JUMP_TIME
		
		# get wall direction and apply force to jump diagonally
		var wall_dir = get_wall_normal().x
		velocity.x = wall_dir * wall_x_force
		velocity.y  = jump_velocity
#endregion





#region abilities
func manage_abilities():
	
	if Input.is_action_pressed("timeslow") and stamina_ui.has_stamina() and not is_dashing:
		debug_label.text = "on"
		Engine.time_scale = 0.3
	else:
		debug_label.text = "off"
		Engine.time_scale = 1.0
	
	
	
	is_dashing = dash.is_dashing()
	
	# dash ability
	if is_on_floor() or is_on_wall():
		has_dashed = false
	
	var can_dash = ( # the requirents to be able to dash
			Input.is_action_just_pressed("dash") 
			and not has_dashed 
			and dash.can_dash 
			and not dash.is_dashing() 
			and not is_parrying
			and not is_on_wall()
			and velocity.x != 0
	)
	
	if can_dash == true: # if can dash, is dashing, has dashed, and then dash towards dash_direction
		is_dashing = true
		has_dashed = true
		dash_dir = sign(direction)
		
		if dash_dir == 0:
			dash_dir = Global.player_dir
		
		audio_manage.dash_play()
		dash.start_dash(sprite, dash_duration)
	
	player_speed = dash_speed if dash.is_dashing() else move_speed



func parry(): # parry function
	if is_on_floor_only():
		is_parrying = true
		player_anim.play("parry")

#endregion





#region misc functions
func hbox_adjust(hbox_x, hbox_y):
	player_hitbox.position = Vector2(hbox_x, hbox_y)



func manage_flip(direction):
	if direction == 0:
		return
	
	parry_hitbox.position = Vector2(direction * 18.5, -1.0)
	
	# flip sprite
	if direction == -1.0:
		sprite.flip_h = true
	elif direction == 1.0:
		sprite.flip_h = false
	
	if is_on_wall_only():
		sprite.flip_h = not sprite.flip_h


var wall_anim_played := false


func update_animations():
	manage_flip(Input.get_axis("moveleft", "moveright"))
	
	if not is_attacking and not is_parrying:
		
		#wall jump anim
		if is_on_wall_only() and not direction == 0:
			if not wall_anim_played:
				hbox_adjust((direction * 1.0), 5.0)
				player_anim.play("wall")
				wall_anim_played = true
		else:
			wall_anim_played = false
			
			# jump anim
			if velocity.y < 0 and is_jumping:
				player_anim.play("jump")
			
			# fall anim
			elif velocity.y > 0 and not is_on_floor():
				player_anim.play("fall")
			
			# run anim
			elif not is_dashing and velocity.x != 0 and is_on_floor():
				player_anim.play("run")
			
			elif is_dashing:
				player_anim.play("dash")
			
			# idle anim
			else:
				hbox_adjust(0.0, 5.0)
				player_anim.play("idle")
#endregion
