extends Control

@onready var stamina: TextureProgressBar = $Stamina
@onready var key_press_delay: Timer = $KeyPressDelay
@onready var frame_timer: FrameTimer = $Stamina/FrameTimer

@onready var player: CharacterBody2D = $".."
@onready var player_sprite: AnimatedSprite2D = $"../PlayerSprite"

var s_timer = 0 # stamina timer
var time_to_wait = 0.5 # time to wait till regen

var regen_speed := 150.0 # regen ammount
var drain_speed := 50.0 # drain ammount
var prev_stamina := 0.0 # previous stamina to detect if value regernates after reducing

var tween: Tween
var current_color: Color

func _change_bar_color(current_color: Color):
	stamina.material.set_shader_parameter("custom_color", current_color)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.shockwave_finish.connect(_invertsbar)
	stamina.value = stamina.max_value # set stamina to max value (100)
	prev_stamina = stamina.value
	modulate.a = 0.0
	key_press_delay.timeout.connect(_on_key_delay_timeout)



func has_stamina() -> bool:
	return stamina.value > 0

func ran_out() -> bool:
	return prev_stamina > 0 and stamina.value <= 0


# option: make bar appear only when button pressed
func _invertsbar():
	_change_bar_color(Color(18.892, 0.0, 0.0, 0.0))

func _process(delta: float) -> void:
	
	var true_delta = get_process_delta_time() / Engine.time_scale
	
	# drain stamina
	if Input.is_action_pressed("timeslow"):
		show_bar()
		stamina.value -= drain_speed * true_delta
		s_timer = 0.0
		key_press_delay.stop()
		if has_stamina():
			_change_bar_color(Color(0.0, 18.892, 18.892, 1.0))
	
	# regen delay
	elif stamina.value < stamina.max_value:
		s_timer += true_delta
		if s_timer >= time_to_wait: # if timer larger than time to wait, regen stamina
			stamina.value += regen_speed * true_delta
		
	# clamp so stamina stays within 0 and max value
	stamina.value = clamp(stamina.value, 0, stamina.max_value)
	
	
	
	if prev_stamina < stamina.max_value and stamina.value >= stamina.max_value:
		_on_stamina_fully_regen(delta)
	
	# fade out when max stamina
	if stamina.value >= stamina.max_value and key_press_delay.is_stopped():
		key_press_delay.start()
		
	prev_stamina = stamina.value


func _on_stamina_fully_regen(delta):
	pass # when i need to detect the bar being filled up after a drain
	
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
