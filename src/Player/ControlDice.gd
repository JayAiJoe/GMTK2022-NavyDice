extends Node2D

class_name ControlDice


func roll(direction : int) -> void:
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")
	$Faces.frame = get_face_up() - 1

func slide(direction : int) -> void:
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")
	
func get_face_up() -> int : 
	return randi() % 6 + 1

