extends Node

@onready var player: CharacterBody2D = $".."
@onready var player_audio: PlayerAudioStreamer = $"../PlayerAudio"



func _ready() -> void:
	player_audio.max_polyphony = 8

func pitch_randomize(min_pitch, max_pitch):
	player_audio.pitch_scale = randf_range(min_pitch, max_pitch)

func play_stop():
	player_audio.stop()

func footstep_play():
	if player.is_dashing == false:
		pitch_randomize(0.8, 1.2)
		player_audio.cycle_play_range(2, 7)

# player_audio.play_sound_index(index, min_pitch, max_pitch)

func dash_play():
		player_audio.play_sound_index(0, 0.95, 1.1)

func jump_play():
	if player.is_wall_jumping == false:
		player_audio.play_sound_index(1, 0.8, 1.2)
	else:
		player_audio.play_sound_index(8, 0.8, 1.2)
