extends Sprite2D

@onready var dash_ghost: Sprite2D = $"."
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
	#if Global.is_timeslow == true:
		#dash_ghost.material.set_shader_parameter("outline_color", Color(0.0, 0.0, 0.0, 1.0))
		#
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 0.0, 0.3)	
	tween.finished.connect(_on_tween_end)

func _on_tween_end() -> void:
	queue_free()
