extends Area2D

var speed : float = 200.0
var direction : Vector2 = Vector2.LEFT

func _physics_process(delta: float) -> void:
	position += speed * direction * delta 
	$Sprite2D.rotation = direction.angle()

func _on_screen_exited() -> void:
	queue_free()

func mirror_flip():
	direction = Vector2 (-direction.x, -direction.y)

func destroy():
	speed = 0
