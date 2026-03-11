extends Node
class_name KonamiCode
## Listens to input and tracks whether successive inputs correctly match
## Configurable time limit between inputs.
## Signals when input is incorrect, when it advances, and when it completes.

@export var input_time_limit: float = 1.0

var konami_code: Array[String] = [ 
	'input_up',
	'input_up',
	'input_down',
	'input_down',
	'input_left',
	'input_right',
	'input_left',
	'input_right',
	'input_b',
	'input_a',
	'input_start' ] # The konami code

var code_point: int = 0

signal code_failed()
#signal code_completed()
signal code_advanced()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_type() && event.is_pressed():
		if event.is_action_pressed(konami_code[code_point]):
			$InputTimer.stop()
			code_point += 1
			if code_point < konami_code.size():
				code_advanced.emit()
				$InputTimer.start(input_time_limit)
			else:
				code_point = 0
				Global.code_completed.emit()
		else:
			code_point = 0
			code_failed.emit()


func _on_input_timer_timeout() -> void:
	code_point = 0
	code_failed.emit()
