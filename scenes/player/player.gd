extends CharacterBody2D

# refer nodes
@onready var player: CharacterBody2D = $"."

@onready var sprite: AnimatedSprite2D = $PlayerSprite
@onready var player_anim = get_node("PlayerAnim")
@onready var player_hitbox: CollisionShape2D = $PlayerHitbox
@onready var stamina_ui: Control = $TimeSlowBar

@onready var player_audio: AudioStreamPlayer = $PlayerAudio
@onready var audio_manage: Node = $AudioManage

@onready var frame_timer: FrameTimer = $FrameTimer
@onready var konami_code: KonamiCode = $KonamiCode

# refer abilities
@onready var dash: Node2D = $Dash
@onready var is_timeslow = false

# manual signals
signal wall_touching # manual signal for wall touch





# triggers shockwave effect
#Global.screen_shock.emit(screen_pos)

# actual player's position
var screen_pos: Vector2:
	get():
		return (global_position - Global.camera.global_position + Vector2(962, 542)) / 2.0





#region variables
# jump
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
var dash_speed := 2000.0
var dash_duration := 0.1

var is_dashing := false
var can_dash = true
var has_dashed = false
var dash_dir := 0

# state variables
var is_attacking := false
var is_jumping := false
var is_wall_jumping := false

# misc
var transition_flash := 0.0
#endregion





#region export variables
@export_category("Velocity Variables")
@export var player_speed: float = 330.0
@export var move_speed: float = 330.0
@export var jump_velocity: float = -480.0

@export_category("Wall Logic Variables")
@export var wall_x_force =  310.0
@export var wall_y_force = 1200.0
@export var wall_slide_speed: float = 30.0
#endregion





func _ready() -> void: # load on start
	# connect to konami code signal
	Global.code_completed.connect(_on_konami_code)

func _process(_delta: float) -> void: # load every frame
	# debug tp to spawn
	if Input.is_action_just_pressed("debug_tp"): # backslash (\)
		global_position = Vector2(0, 0)



#region physics and movement
func _physics_process(delta: float) -> void: # loads every physics delta
	
	if is_on_wall(): # emit signal when wall touched
		wall_touching.emit()
	
	
	# player direction (from left right input)
	direction = Input.get_axis("moveleft", "moveright")
	if direction != 0:
		Global.player_dir = int(direction) # update global player's direction when not still
	
	
	# get and apply gravity (reduced to 980.0 * 0.8)
	gravity = get_gravity().y
	velocity.y += gravity * delta
	

	
	# on wall variable to identify wall state
	on_wall = is_on_wall_only() and not direction == 0
	
	
	## state machine
	if on_wall: # if on wall
		wall_process()
	elif is_on_floor(): # if on floor
		coyote_timer = COYOTE_TIME # coyote time
		floor_process()
	#else: # if any air state code is needed
		#air_process()
#endregion





	#region movement
	# handle movement
	if dash.is_dashing(): # if dashing, do not change direction
		velocity.x = dash_dir * dash_speed
	elif not is_wall_jumping: # if not wall jumping, move left and right by player direction
		velocity.x = direction * player_speed
	else:
		if abs(velocity.x) < player_speed:
			velocity.x += direction * player_speed * 0.09
	
	handle_jump_buffer()



	# jump cut
	if Input.is_action_just_released("jump") and is_jumping and velocity.y < 0:
		velocity.y *= 0.3

	# set max falling speed
	var max_fall_speed: float = 1000.0
	velocity.y = clamp(velocity.y, float(-INF), max_fall_speed)



	manage_buffer(delta)
	manage_abilities(delta)
	
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



func handle_jump_buffer():
	# jump buffer reset
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	if jump_buffer_timer <= 0:
		return
		
	# wall jump
	if on_wall and not is_wall_jumping:
		
		var wall_dir = get_wall_normal().x
		
		is_jumping = true
		is_wall_jumping = true
		wall_jump_timer = WALL_JUMP_TIME
		
		# get wall direction and apply force to jump diagonally
		velocity.x = wall_dir * wall_x_force
		velocity.y  = jump_velocity
		
		jump_buffer_timer = 0
		return
		
	## handle jump
	if Global.konami_on or is_on_floor() or coyote_timer > 0:
		coyote_timer = 0.0
		velocity.y = jump_velocity
		is_jumping = true
		jump_buffer_timer = 0.0
#endregion





#region state functions
func floor_process():
	
	if not is_on_floor():
		return
	
	# if on floor and not moving up, not jumping or wall jumping
	if velocity.y == 0:
		is_jumping = false
		is_wall_jumping = false



func wall_process():
	
	if velocity.y <= wall_slide_speed:
		return
		
	# if on wall but not moving towards wall, wall jump is canceled
	if velocity.x == 0:
		is_wall_jumping = false
	
	
	# wall slide
	if not is_wall_jumping:
		velocity.y =  lerp(velocity.y, wall_slide_speed, 0.3)
#endregion





#region abilities
func transition_screen(target_flash, flash_speed, delta):
	transition_flash = lerp(transition_flash, target_flash, flash_speed * delta)
	Global.flash_visible.set_flash(transition_flash)
	print(typeof(dash_duration))

func manage_abilities(delta):
	
	if Input.is_action_pressed("timeslow") and stamina_ui.has_stamina():
		Global.screen_shock.emit(screen_pos, false)
		is_timeslow = true
	else:
		Global.screen_shock.emit(screen_pos, true)
		is_timeslow = false
	
	
	if is_timeslow:
		Engine.time_scale = 0.5
	else:
		Engine.time_scale = 1.0
	
	
	if dash.is_dashing():
		is_dashing = true
	elif is_dashing and not dash.is_dashing():
		is_dashing = false
	
# dash ability
	if is_on_floor() or is_on_wall():
		has_dashed = false
		
	var dash_pressed := Input.is_action_just_pressed("dash")

	var can_dash: bool = (
		dash_pressed
		and (Global.konami_on or not has_dashed)
		and dash.can_dash
		and not dash.is_dashing()
		and not is_on_wall()
	)
	
	if can_dash:
		has_dashed = true
		is_dashing = true
		
		# get dash direction immediately
		if direction != 0:
			dash_dir = sign(direction)
		else:
			dash_dir = -1 if sprite.flip_h else 1
			
		player_anim.play("dash")
		audio_manage.dash_play()
		
		dash.start_dash(sprite, dash_duration)
	
	player_speed = dash_speed if dash.is_dashing() else move_speed

#endregion





#region misc functions
func _on_konami_code() -> void:
	Global.konami_on = !Global.konami_on

func hbox_adjust(hbox_x, hbox_y):
	player_hitbox.position = Vector2(hbox_x, hbox_y)



func manage_flip(direction):
	if direction == 0:
		return
	
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
		
	if frame_timer.running or dash.is_dashing():
		player_anim.play("dash")
		return
	
	if not is_attacking:
		
		#wall jump anim
		if is_on_wall_only() and not direction == 0:
			if not wall_anim_played:
				hbox_adjust((direction * 1.5), 5.0)
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
			
			# idle anim
			else:
				hbox_adjust(0.0, 5.2)
				player_anim.play("idle")
#endregion
