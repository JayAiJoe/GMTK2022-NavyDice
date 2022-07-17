tool
extends TextureButton

export(String, FILE) var next_scene_path := ""

func _get_configuration_warning() -> String:
	return "Next scene path cannot be empty" if next_scene_path == "" else ""

func _on_Button_button_up() -> void:
	get_tree().paused = false
	SceneTracker.prev_path = get_tree().current_scene.filename
	get_tree().change_scene(next_scene_path)
