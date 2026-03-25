extends Node
class_name FrameTimer

@export var frames: int = 1

signal timeout

var running := false

func start():
	if running:
		return
		
	running = true
	
	for i in range(frames):
		await get_tree().process_frame
	
	running = false
	timeout.emit()
