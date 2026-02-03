extends Control
const LEVEL_DEV = preload("uid://r3t8vyh6hk05")
#const PARALLAX_PLACEHOLDER = preload("uid://bakqi37iis4tj")

@onready var btn_audio: MultiAudioStreamer = $ButtonAudio

@onready var main_menu: Panel = $MainMenu
@onready var options: Panel = $Options
@onready var quit_ensure: Panel = $QuitEnsure

@onready var start_btn: Button = $MainMenu/StartMenuBtns/MainBtns/StartBtn

func _ready() -> void:
	
	start_btn.grab_focus()
	
	main_menu.visible = true
	options.visible = false
	quit_ensure.visible = false


func esc_test():
	if Input.is_action_pressed("ui_cancel"):
		print("test")
		options.visible = false
		quit_ensure.visible = false







func _on_start_btn_pressed() -> void:
	btn_audio.play_sound_index(1)
	Global.game_layer.load_scene(LEVEL_DEV)
	Global.ui_layer.unload_current()

	#var _inst = PARALLAX_PLACEHOLDER.instantiate()
	#Global.game_node.add_child(_inst)


func _on_options_btn_pressed() -> void:
	main_menu.visible = false
	options.visible = true




func _on_quit_btn_pressed() -> void:
	btn_audio.play_sound_index(1)
	quit_ensure.visible = true

func _on_quit_yes_pressed() -> void:
	get_tree().quit()

func _on_quit_no_pressed() -> void:
	quit_ensure.visible = false



func _on_start_btn_mouse_entered() -> void:
	btn_audio.play_sound_index(0)

func _on_options_btn_mouse_entered() -> void:
	btn_audio.play_sound_index(0)

func _on_quit_btn_mouse_entered() -> void:
	btn_audio.play_sound_index(0)
