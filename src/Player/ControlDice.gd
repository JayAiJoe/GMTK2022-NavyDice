extends Node2D

class_name ControlDice

var new_pos_ori
var current_face = 0
var current_ori = 0

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
	
func change_face(current_face : int, current_ori : int, direction : int):
	return new_pos_ori[current_face][current_ori][direction]
	
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
	
	current_face = randi()%6 + 1
	current_ori = randi()%4
	print(change_face(1,1,1))
