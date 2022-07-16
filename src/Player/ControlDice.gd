extends Node2D

class_name ControlDice

signal consumed

var dice_state
var anim_dir

func _ready():
	anim_dir = ["RollEast", "RollNorth", "RollWest", "RollSouth"]
	dice_state = [randi()%6 + 1, 0]
	$OldFaces.frame = get_face_up() - 1
	
func _on_ControlDice_area_entered(area: Area2D) -> void:
	load_and_fire(area)

func roll(direction : int) -> void:
	dice_state = change_face(dice_state, direction)
	$NewFaces.frame = get_face_up() - 1
	$RollAnimation.play(anim_dir[direction])
	
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12*1/0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	
	yield($MoveTween,"tween_completed")
	
func set_old_faces() -> void:
	$OldFaces.frame = get_face_up() - 1
	$OldFaces.position = Vector2(0,0)
	$OldFaces.scale = Vector2(0.5, 0.5)

func slide(direction : int) -> void:
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")

func get_face_up() -> int : 
	return dice_state[0]
	
func change_face(curr_state, direction : int):
	return Databases.next_dice_state[curr_state[0]][curr_state[1]][direction]
	
func load_and_fire(area : Area2D):
	if area is Cannon:
		(area as Cannon).fire(Vector2(get_face_up(), get_face_up()), get_face_up())
		consume()

func fall():
	$RollAnimation.play("Fall")
	

func consume():
	emit_signal("consumed")
	queue_free()
