extends AudioStreamPlayer
class_name PlayerAudioStreamer

@export var sounds: Array[AudioStream]

var current_index: int = 0


func play_sound_index(index, min_pitch, max_pitch):
	var poly_sfx = AudioStreamPlayer.new()
	poly_sfx.stream = sounds[index]
	poly_sfx.finished.connect(poly_sfx.queue_free)
	add_child(poly_sfx)
	poly_sfx.pitch_scale = randf_range(min_pitch, max_pitch)
	poly_sfx.play()

func random_play():
	stream = sounds.pick_random()
	play()



func random_play_index(min_index: int, max_index: int):
	if sounds.is_empty():
		return
	
	min_index = clamp(min_index, 0, sounds.size() - 1)
	max_index = clamp(max_index, 0, sounds.size() - 1)
	
	if min_index > max_index:
		return
	
	var index = randi_range(min_index, max_index)
	stream = sounds[index]
	play()



func cycle_play_range(min_index: int, max_index: int):
	if sounds.is_empty():
		return
	
	min_index = clamp(min_index, 0, sounds.size() - 1)
	max_index = clamp(max_index, 0, sounds.size() - 1)
	
	if min_index > max_index:
		return
	
	if current_index < min_index or current_index > max_index:
		current_index = min_index

	stream = sounds[current_index]
	play()

	current_index += 1
	

	if current_index > max_index:
		current_index = min_index
