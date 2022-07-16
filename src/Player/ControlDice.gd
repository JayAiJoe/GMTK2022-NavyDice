extends Node2D

class_name ControlDice

func _on_ControlDice_area_entered(area: Area2D) -> void:
	load_and_fire(area)

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

func load_and_fire(area : Area2D):
	if area is Cannon:
		(area as Cannon).fire(Vector2(get_face_up(), get_face_up()))
		queue_free()



