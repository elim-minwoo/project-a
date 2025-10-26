extends Area2D



func _on_area_entered(area):
	if area.has_method("mirror_flip"):
		area.mirror_flip()
	if area.has_method("stagger"):
		area.stagger()
