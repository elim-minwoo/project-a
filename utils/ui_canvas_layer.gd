extends LoadableLayer

func load_scene(scene: PackedScene) -> Node:
	var _scene = scene.instantiate()
	add_child(_scene)
	return _scene
