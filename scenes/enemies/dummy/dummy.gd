extends Area2D

@onready var dummy_sprite: Sprite2D = $Sprite2D

const DUMMY_PROJECTILE = preload("uid://coednfjc0rx2q")



func _ready() -> void:
	mouse_entered.connect(_on_hovered.bind(true))
	mouse_exited.connect(_on_hovered.bind(false))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_input"):
		var projectile_temp = DUMMY_PROJECTILE.instantiate()
		projectile_temp.direction = -1
		add_child(projectile_temp)

func _on_hovered(hovered: bool) -> void:
	print(dummy_sprite.material)
	dummy_sprite.material.set_shader_parameter("thickness", 0.8 if hovered else 0.0)
