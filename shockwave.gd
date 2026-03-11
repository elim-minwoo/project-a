extends Sprite2D

@onready var mat = material

var start_sw:= 0.0

func _ready() -> void:
	Global.screen_shock.connect(trigger_shockwave)

func process() -> void:
	pass

func trigger_shockwave(pos: Vector2, shockwave_inverse) -> void:
	var uv = pos / get_viewport_rect().size
	mat.set_shader_parameter("center", uv)
	
# start_shockwave, target_shockwave, shockwave_duration
	if shockwave_inverse == false:
		_shockwave(0.0, 1.0, 0.5)
	else:
		_shockwave(start_sw, 0.0, 0.3)


func _shockwave(start_sw, target_sw, shockwave_duration) -> void:
	mat.set_shader_parameter("progress", start_sw)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/progress", target_sw, shockwave_duration)
