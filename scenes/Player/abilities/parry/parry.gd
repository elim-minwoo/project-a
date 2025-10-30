extends Area2D

@onready var player_audio: AudioStreamPlayer = $"../PlayerAudio"
@onready var multi_audio_streamer: MultiAudioStreamer = $MultiAudioStreamer

func _ready() -> void:
	area_entered.connect(_on_parry_area_entered)

func _on_parry_area_entered(area: Area2D) -> void:
	if area.has_method("reflect"):
		area.reflect(self)

func reflected() -> void:
	multi_audio_streamer.random_play()
	
