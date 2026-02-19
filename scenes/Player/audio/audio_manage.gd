extends Node

@onready var player: CharacterBody2D = $".."
@onready var player_audio: PlayerAudioStreamer = $"../PlayerAudio"

func footstep_play():
	if player.is_dashing == false:
		player_audio.cycle_play_range(0, 1)
