extends ColorRect

@onready var mat = material
@onready var shockwave_timer: Timer = $ShockwaveTimer

var can_trigger := true
var shockwave_duration := 0.6

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
	mat.set_shader_parameter("progress", 0.0)
	
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/progress", 1.0, shockwave_duration)
	tween.finished.connect(_on_shockwave_finished)



func _on_shockwave_finished() -> void:
	shockwave_timer.start()	

func _on_cooldown_finished() -> void:
	can_trigger = true

#func _input(event: InputEvent) -> void:
	#if event is  and event.pressed:
		#trigger_shockwave(event.position)
