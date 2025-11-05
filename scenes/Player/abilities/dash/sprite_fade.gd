extends AnimatedSprite2D

func UpdateAlpha(newValue: float):
	modulate = Color(0.008, 0.708, 1.0, 1.0)
	modulate.a = newValue
	
func StartFading():
	var trailTween = get_tree().create_tween()
	trailTween.set_ignore_time_scale(true)
	trailTween.tween_method(UpdateAlpha, 0.5, 0.0, 1.0)
