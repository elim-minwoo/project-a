extends LoadableLayer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func load_scene(scene: PackedScene):
	var _scene = scene.instantiate()
	sub_viewport.add_child(_scene)
	return _scene
