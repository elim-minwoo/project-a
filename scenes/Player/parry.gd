extends Area2D

func _ready() -> void:
	area_entered.connect(_on_parry_area_entered)

func _on_parry_area_entered(area: Area2D) -> void:
	if area.has_method("reflect"):
		area.reflect()
