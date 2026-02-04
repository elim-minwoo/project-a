extends Control
const LEVEL_DEV = preload("uid://r3t8vyh6hk05")

@onready var btn_audio: MultiAudioStreamer = $ButtonAudio

@onready var main_menu: Panel = $MainMenu
@onready var options_menu: Panel = $Options
@onready var quit_ensure: Panel = $QuitEnsure

@onready var start_btn: Button = $MainMenu/StartMenuBtns/MainBtns/StartBtn
@onready var options_btn: Button = $MainMenu/StartMenuBtns/MainBtns/OptionsBtn
@onready var quit_btn: Button = $MainMenu/StartMenuBtns/MainBtns/QuitBtn

@onready var quit_yes: Button = $QuitEnsure/QuitYes
@onready var quit_no: Button = $QuitEnsure/QuitNo

@export var sound_playing_buttons: Array[Button]
@export var click_playing_buttons: Array[Button]



func _ready() -> void:
	
	start_btn.grab_focus()
	
	main_menu.visible = true
	options_menu.visible = false
	quit_ensure.visible = false
	
	for button in sound_playing_buttons:
		button.focus_entered.connect(_on_btn_focus)
		button.mouse_entered.connect(_on_btn_hover)
	for button in click_playing_buttons:
		button.pressed.connect(_on_btn_clicked)

func _process(delta: float) -> void:
	esc_test()

func esc_test():
	if Input.is_action_just_pressed("ui_cancel") and (options_menu.visible == true or quit_ensure.visible == true):
		start_btn.grab_focus()
		btn_audio.play_sound_index(2)
		options_menu.visible = false
		quit_ensure.visible = false







func _on_start_btn_pressed() -> void:
	btn_audio.play_sound_index(4)
	await btn_audio.finished
	
	Global.game_layer.load_scene(LEVEL_DEV)
	Global.ui_layer.unload_current()

func _on_options_btn_pressed() -> void:
	options_menu.visible = true

func _on_quit_btn_pressed() -> void:
	quit_ensure.visible = true
	quit_no.grab_focus()
	btn_audio.play_sound_index(3)
	





func _on_btn_focus() -> void:
	btn_audio.play_sound_index(0)
	
func _on_btn_hover() -> void:
	btn_audio.play_sound_index(0)

func _on_btn_clicked() -> void:
	btn_audio.play_sound_index(1)



func _on_quit_yes_pressed() -> void:
	get_tree().quit()

func _on_quit_no_pressed() -> void:
	quit_ensure.visible = false
	quit_btn.grab_focus()
	btn_audio.play_sound_index(4)
