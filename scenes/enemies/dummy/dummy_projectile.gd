extends Area2D

var speed : float = 200.0
@export var direction: int = 1 : set = set_direction

func set_direction(value: int) -> void:
	direction = value
	$Sprite2D.flip_h = direction < 0

func _process(delta: float) -> void:
	position.x += speed * direction * delta

func reflect():
	direction *= -1
	speed *= 2
	set_direction(direction)
