extends AudioStreamPlayer2D

var bg_music_path = preload("res://assets/sounds/bg_music2.mp3")
var checkpoint = null

func _ready() -> void:
	position.x = 800
	volume_db = -3
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_stream(bg_music_path)
	toggle_music()
	
func toggle_music() -> void:
	if playing:
		checkpoint = get_playback_position()
		stop()
	elif checkpoint:
		play(checkpoint)
	else:
		play()
