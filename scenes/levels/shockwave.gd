extends Sprite2D

@onready var mat = material

var shockwave_tween: Tween

func _ready() -> void:
	Global.screen_shock.connect(trigger_shockwave)

func trigger_shockwave(pos: Vector2, shockwave_inverse) -> void:
	var uv = pos / get_viewport_rect().size
	mat.set_shader_parameter("center", uv)

	var current_progress = mat.get_shader_parameter("progress")
	if snappedf(current_progress, 0.035) == 0.0:
		Global.shockwave_finish.emit()

	if shockwave_inverse == false:
		_shockwave(current_progress, 1.0, 0.25)
	else:
		_shockwave(current_progress, 0.0, 0.1)


func _shockwave(start_sw, target_sw, shockwave_duration) -> void:
	mat.set_shader_parameter("progress", start_sw)

	if shockwave_tween:
		shockwave_tween.kill()

	shockwave_tween = create_tween()
	shockwave_tween.tween_property(mat, "shader_parameter/progress", target_sw, shockwave_duration)
