extends AudioStreamPlayer
class_name MultiAudioStreamer

@export var sounds: Array[AudioStream]

func play_sound_index(index):
	stream = sounds[index]
	play()

func random_play():
	stream = sounds.pick_random()
	play()
