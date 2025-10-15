extends AnimatedSprite2D

func UpdateAlpha(newValue: float):
	modulate = Color(0.008, 0.708, 1.0, 1.0)
	modulate.a = newValue
	
func StartFading():
	var newTween = get_tree().create_tween()
	newTween.tween_method(UpdateAlpha, 0.5, 0.0, 1.0)
