extends AudioStreamPlayer2D


var sound_paths = {
	"button" : preload("res://assets/sounds/button_press.mp3"),
	"button2" : preload("res://assets/sounds/button_press2.mp3"),
	"cannon" : preload("res://assets/sounds/cannon_fire.mp3"),
	"thud" : preload("res://assets/sounds/thud1.mp3"),
	"thud2" : preload("res://assets/sounds/thud2.mp3"),
	"thud3" : preload("res://assets/sounds/thud3.mp3")
}

func play_sound(sound : String, volume : int) -> void:
	volume_db = -15 + 5 * volume
	set_stream(sound_paths[sound])
	play()

