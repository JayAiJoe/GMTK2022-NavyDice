extends Node2D

class_name ControlDice

signal consumed

var new_pos_ori
var dice_state

func _ready():
	new_pos_ori = {
		1: {0:[[4,0],[2,0],[3,0],[5,0]],
			1:[[5,1],[4,1],[2,1],[3,1]],
			2:[[3,2],[5,2],[4,2],[2,2]],
			3:[[2,3],[3,3],[5,3],[4,3]]},
			
		2: {0:[[4,1],[6,0],[3,3],[1,0]],
			1:[[1,1],[4,2],[6,1],[3,0]],
			2:[[3,1],[1,2],[4,3],[6,2]],
			3:[[6,3],[3,2],[1,3],[4,0]]},
			
		3: {0:[[1,0],[2,1],[6,2],[5,3]],
			1:[[5,0],[1,1],[2,2],[6,3]],
			2:[[6,0],[5,1],[1,2],[2,3]],
			3:[[2,0],[6,1],[5,2],[1,3]]},
		
		4: {0:[[6,2],[2,3],[1,0],[5,1]],
			1:[[5,2],[6,3],[2,0],[1,1]],
			2:[[1,2],[5,3],[6,0],[2,1]],
			3:[[2,2],[1,3],[5,0],[6,1]]},
		
		5: {0:[[4,3],[1,0],[3,1],[6,0]],
			1:[[6,1],[4,0],[1,1],[3,2]],
			2:[[3,3],[6,2],[4,1],[1,2]],
			3:[[1,3],[3,0],[6,3],[4,2]]},
			
		6: {0:[[4,2],[5,0],[3,2],[2,0]],
			1:[[2,1],[4,3],[5,1],[3,3]],
			2:[[3,0],[2,2],[4,0],[5,2]],
			3:[[5,3],[3,1],[2,3],[4,1]]},
	}
	dice_state = [randi()%6 + 1, randi()%4 ]
	
func _on_ControlDice_area_entered(area: Area2D) -> void:
	load_and_fire(area)

func roll(direction : int) -> void:
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	
	yield($MoveTween,"tween_completed")
	dice_state = change_face(dice_state, direction)
	$Faces.frame = get_face_up() - 1

func slide(direction : int) -> void:
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")

func get_face_up() -> int : 
	return dice_state[0]
	
func change_face(curr_state, direction : int):
	return new_pos_ori[curr_state[0]][curr_state[1]][direction]
	
func load_and_fire(area : Area2D):
	if area is Cannon:
		(area as Cannon).fire(Vector2(get_face_up(), get_face_up()), get_face_up())
		consume()

func consume():
	emit_signal("consumed")
	queue_free()
