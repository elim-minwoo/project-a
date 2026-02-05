extends Sprite2D

func _ready() -> void:
	add_ghosting()

func set_property(pos_ch,scale_ch):
	global_position = pos_ch
	scale = scale_ch
	

func add_ghosting():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"self_modulate",Color(1.0, 1.0, 1.0, 1.0),0.45)
	await tween.finished
	queue_free() 
