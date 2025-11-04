extends Node2D

const dash_delay = 0.7

@onready var duration_timer = $DashDuration
var can_dash = true

func start_dash(duration):
	if not can_dash:
		return
	can_dash = false
	duration_timer.wait_time = duration
	duration_timer.start()
	
func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true


func _on_dash_duration_timeout() -> void:
	end_dash()
