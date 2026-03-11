extends Sprite2D

@onready var mat = material
@onready var shockwave_timer: Timer = $ShockwaveTimer

@export var shockwave_duration := 1.0

var shockwave_inverse := false
var can_trigger := true

func _ready() -> void:
	shockwave_timer.wait_time = shockwave_duration + 0.05
	shockwave_timer.timeout.connect(_on_cooldown_finished)
	
	Global.screen_shock.connect(trigger_shockwave)



func trigger_shockwave(pos: Vector2) -> void:
	if not can_trigger:
		return
		
	can_trigger = false
	
	var uv = pos / get_viewport_rect().size
	mat.set_shader_parameter("center", uv)
	
	if shockwave_inverse == false:
		_shockwave(0.0, 1.0)
	else:
		_shockwave(1.0, 0.0)

func _shockwave(start_sw, target_sw) -> void:
	mat.set_shader_parameter("progress", start_sw)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/progress", target_sw, shockwave_duration)
	tween.finished.connect(_on_shockwave_finished)


func _on_shockwave_finished() -> void:
	shockwave_timer.start()	

func _on_cooldown_finished() -> void:
	can_trigger = true

##func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		##trigger_shockwave(event.position)
