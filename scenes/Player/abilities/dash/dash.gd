extends Node2D

const dash_delay = 0.6

@onready var player: CharacterBody2D = $".."


@onready var duration_timer = $DashDuration
@onready var ghost_timer: Timer = $GhostTimer
const dash_ghost = preload("uid://2t33ax3als6d")



var can_dash = true
var sprite

func _ready() -> void:
	player.wall_touched.connect(_on_player_touched_wall)

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
	
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h



func _on_player_touched_wall():
	ghost_timer.stop()



func is_dashing() -> bool:
	return !duration_timer.is_stopped()

func end_dash() -> void:
	ghost_timer.stop()
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true



func _on_dash_duration_timeout() -> void:
	end_dash()

func _on_ghost_timer_timeout() -> void:
	instance_ghost()
