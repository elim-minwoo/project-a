extends Node

@onready var player: CharacterBody2D = $".."
@onready var player_audio: PlayerAudioStreamer = $"../PlayerAudio"

func pitch_randomize(min_pitch, max_pitch):
	player_audio.pitch_scale = randf_range(min_pitch, max_pitch)

func play_stop():
	player_audio.stop()

func footstep_play():
	if player.is_dashing == false:
		pitch_randomize(0.8, 1.2)
		player_audio.cycle_play_range(2, 7)

func jump_play():
	if player.is_wall_jumping == false:
		pitch_randomize(0.8, 1.2)
		player_audio.play_sound_index(1)
