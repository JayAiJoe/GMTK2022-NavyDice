extends TextureButton

func _ready() -> void:
	update_text()
	

func _on_MusicButton_button_up() -> void:
	BgMusic.toggle_music()
	update_text()
	

func update_text():
	if BgMusic.playing:
		$Label.text = "Music: On"
	else:
		$Label.text = "Music: Off"
