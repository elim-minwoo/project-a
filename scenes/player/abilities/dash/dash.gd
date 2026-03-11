extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var player_sprite: AnimatedSprite2D = $"../PlayerSprite"

@onready var duration_timer: Timer = $DashDuration
@onready var ghost_timer: Timer = $GhostTimer
@onready var frame_timer: FrameTimer = $FrameTimer
@onready var outline_frame_timer: FrameTimer = $OutlineFrameTimer
@onready var dash_delay: Timer = $DashDelay

const dash_ghost = preload("uid://2t33ax3als6d")
var can_dash = true
var sprite
var infinite_dash := false


func _ready() -> void:
	player.wall_touching.connect(_on_player_touching_wall)

func _process(delta: float) -> void:
	if Global.konami_on:
		infinite_dash = true
	else:
		infinite_dash = false
		
	
	if player.is_dashing == false and player.is_timeslow == false:
		outline_frame_timer.start()
		await outline_frame_timer.timeout
		player_sprite.material.set_shader_parameter("outline_color", Color(0.0, 0.0, 0.0, 1.0))



func start_dash(sprite, duration: float) -> void:
	self.sprite = sprite
	
	if not can_dash:
		return
	can_dash = false
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_timer.start()
	
	instance_ghost()



func instance_ghost():
	var ghost:= dash_ghost.instantiate() as Sprite2D
	get_parent().get_parent().add_child(ghost)
	
	var current_frame_index = sprite.frame
	var frame = sprite.sprite_frames.get_frame_texture("dash", current_frame_index)
	
	ghost.texture = frame
	ghost.z_index = -1
	
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h



func _on_player_touching_wall():
	ghost_timer.stop()


func is_dashing() -> bool:
	return !duration_timer.is_stopped()

func end_dash() -> void:
	frame_timer.start()
	await frame_timer.timeout # let trail appear for a bit more time
	ghost_timer.stop()
	
	if infinite_dash:
		can_dash = true
	else:
		dash_delay.start()
		await dash_delay.timeout
		can_dash = true



func _on_dash_duration_timeout() -> void:
	end_dash()

func _on_ghost_timer_timeout() -> void:
	instance_ghost()
	
