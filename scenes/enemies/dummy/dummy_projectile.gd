extends Area2D
class_name ParryableProjectile

var speed : float = 150.0
var is_parrying := false
var been_parried : bool = false
@export var direction: int = 1 : set = set_direction



func set_direction(value: int) -> void:
	direction = value
	$Sprite2D.flip_h = direction < 0


func _process(delta: float) -> void:
	position.x += speed * direction * delta


func reflect(reflector: Node2D):
	reflector.reflected()
	frame_freeze(0.0, 0.25)
	
	if not been_parried:
		been_parried = true
		direction *= -(Global.player_dir)
		speed *= 2
	set_direction(direction)


func frame_freeze(timeScale : float, duration : float):
	Global.is_parrying = true
	Global.flash_visible.set_flash(0.3)
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	Global.flash_visible.set_flash(0.0)
	Global.is_parrying = false
