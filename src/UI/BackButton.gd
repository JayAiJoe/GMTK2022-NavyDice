extends Control



func _on_BackButton_button_up() -> void:
	if SceneTracker.prev_path != "":
		get_tree().paused = false
		get_tree().change_scene(SceneTracker.prev_path)
