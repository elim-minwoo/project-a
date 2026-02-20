extends Control

@onready var stamina: TextureProgressBar = $Stamina
@onready var key_press_delay: Timer = $KeyPressDelay

var s_timer = 0 # stamina timer
var time_to_wait = 0.5 # time to wait till regen

var regen_speed := 100.0 # regen ammount
var drain_speed := 120.0 # drain ammount

var tween : Tween



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stamina.value = stamina.max_value # set stamina to max value (100)
	modulate.a = 0.0
	key_press_delay.timeout.connect(_on_key_delay_timeout)

func has_stamina() -> bool:
	return stamina.value > 0



func _process(delta: float) -> void:
	
	# drain stamina
	if Input.is_action_pressed("timeslow"):
		show_bar()
		stamina.value -= drain_speed * delta
		s_timer = 0.0
		key_press_delay.stop()
		
	# regen delay
	elif stamina.value < stamina.max_value:
		s_timer += delta
		if s_timer >= time_to_wait: # if timer larger than time to wait, regen stamina
			stamina.value += regen_speed * delta
			
	# clamp so stamina stays within 0 and max value
	stamina.value = clamp(stamina.value, 0, stamina.max_value)
	
	# fade out when max stamina
	if stamina.value >= stamina.max_value and key_press_delay.is_stopped():
		key_press_delay.start()



func _on_key_delay_timeout() -> void:
	if stamina.value >= stamina.max_value:
		fade_out()

func show_bar() -> void:
	if tween:
		tween.kill()
	modulate.a = 1.0

func fade_out() -> void:
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)	
