extends Control
const LEVEL_DEV = preload("uid://r3t8vyh6hk05")

func _on_start_button_pressed() -> void:
	Global.game_layer.load_scene(LEVEL_DEV)
	Global.ui_layer.unload_current()
	
