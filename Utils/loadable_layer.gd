extends CanvasLayer
class_name LoadableLayer

func load_scene(scene: PackedScene):
	return

func unload_current():
	for child in get_children():
		child.queue_free()
