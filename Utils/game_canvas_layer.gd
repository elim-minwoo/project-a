extends LoadableLayer

@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport

func load_scene(scene: PackedScene):
	var _scene = scene.instantiate()
	game_viewport.add_child(_scene)
	return _scene
