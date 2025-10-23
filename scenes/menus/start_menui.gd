extends Control
const LEVEL_DEV = preload("uid://r3t8vyh6hk05")
const PARALLAX_PLACEHOLDER = preload("uid://bakqi37iis4tj")

func _on_start_button_pressed() -> void:
	Global.game_layer.load_scene(LEVEL_DEV)
	Global.ui_layer.unload_current()
	
	var _inst = PARALLAX_PLACEHOLDER.instantiate()
	Global.game_node.add_child(_inst)
	
