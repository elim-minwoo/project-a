extends Control

@onready var stamina: TextureProgressBar = $Stamina

var s_timer = 0 # stamina timer
var time_to_wait = 0.5 # time to wait till regen

var regen_speed := 40.0 # regen ammount
var drain_speed := 80.0 # drain ammount


func has_stamina() -> bool:
	return stamina.value > 0



func _ready() -> void:
	stamina.value = stamina.max_value # set stamina to max value (100)



func _process(delta: float) -> void:
	
	# drain stamina
	if Input.is_action_pressed("timeslow"):
		stamina.value -= drain_speed * delta
		s_timer = 0.0
		
	# regen delay
	elif stamina.value < stamina.max_value:
		s_timer += delta
		
		if s_timer >= time_to_wait: # if timer larger than time to wait, regen stamina
			stamina.value += regen_speed * delta
			
	# clamp so stamina stays within 0 and max value
	stamina.value = clamp(stamina.value, 0, stamina.max_value)
