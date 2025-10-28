extends Area2D

var speed : float = 200.0
@export var direction: int = 1 : set = set_direction

func set_direction(value: int) -> void:
	direction = value
	$Sprite2D.flip_h = direction < 0

func _process(delta: float) -> void:
	position.x += speed * direction * delta

func reflect():
	frame_freeze(0.0, 0.25)
	direction *= -1
	speed *= 2
	set_direction(direction)

func frame_freeze(timeScale : float, duration : float):
	Global.flash_visible.set_flash(0.5)
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	Global.flash_visible.set_flash(0.0)
