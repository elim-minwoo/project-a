extends CharacterBody2D

const DUMMY_PROJECTILE = preload("uid://coednfjc0rx2q")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_input"):
		var projectile_temp = DUMMY_PROJECTILE.instantiate()
		projectile_temp.direction = -1
		add_child(projectile_temp)
