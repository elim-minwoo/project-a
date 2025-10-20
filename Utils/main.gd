extends Node

const START_MENU = preload("uid://ckcx3loo288dy")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main_scene = self
	
	Global.ui_layer = $UICanvasLayer
	Global.game_layer = $GameCanvasLayer2

	Global.ui_layer.load_scene(START_MENU)
