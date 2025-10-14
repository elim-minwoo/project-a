extends Camera2D

@onready var ground: TileMap = $"../ground"
@onready var player: CharacterBody2D = $"../Player"

@export var horizontal_dead_zone = 30
@export var vertical_dead_zone = 30	
@export var follow_speed = 120.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_camer_limits()
	
func _physics_process(delta: float) -> void:
	update_camera_position(delta)

func setup_camer_limits():
	global_position = player.global_position
	var used_rect = ground.get_used_rect()
	var cell_size = ground.tile_set.tile_size
	var map_width = used_rect.size.x * cell_size.x
	var map_height = used_rect.size.y * cell_size.y
	
	limit_left = used_rect.position.x * cell_size.x
	limit_right = limit_left + map_width
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = limit_top + map_height
	
	print("Tilemap Limits: ", limit_left, ", ", limit_right, ", ", limit_top, ", ", 'limit_bottom', ", ")
	print("Tilemap Size (px): ", map_width, "x", map_height, "y")

func update_camera_position(delta):
	if not player:
		return
		
	var player_pos = player.global_position
	var camera_pos = global_position
	var viewport_size = get_viewport_rect().size / zoom
	
	# calculate target pos
	var target_pos = camera_pos

	# horizontal movement logic
	if abs(player_pos.x - camera_pos.x) > horizontal_dead_zone: 
		target_pos.x = player_pos.x
		
	# vertical movement
	if player_pos.y < camera_pos.y - vertical_dead_zone:
		target_pos.y = player_pos.y
	elif player_pos.y > camera_pos.y + vertical_dead_zone:
		target_pos.y = player_pos.y
 
	# clamp target pos
	var min_x = limit_left + viewport_size.x / 2
	var max_x = limit_right - viewport_size.x / 2
	var min_y = limit_top + viewport_size.y / 2
	var max_y = limit_bottom - viewport_size.y / 2

	# smoothly move to taarget
	position.x = move_toward(position.x, target_pos.x, follow_speed * delta)
	
	if player_pos.y > camera_pos.y: # falling
		position.y = move_toward(position.y, target_pos.y, player.velocity.y)
	else:
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)
