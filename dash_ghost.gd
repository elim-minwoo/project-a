extends Sprite2D

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	tween.finished.connect(_on_tween_end)

func _on_tween_end(object : Object, key: NodePath) -> void:
	tween.tween_callback(queue_free)
