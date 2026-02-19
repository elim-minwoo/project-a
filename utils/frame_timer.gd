extends Node
class_name FrameTimer

@export var frames: int = 1

signal timeout

func start():
	for i in range(frames):
		await get_tree().process_frame
	
	timeout.emit()
