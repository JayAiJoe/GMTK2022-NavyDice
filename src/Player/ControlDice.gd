extends Node2D

class_name ControlDice

signal consumed

var dice_state
var anim_dir
var last_dir

#modifiers
var blocker = false
var gooey = 0
var icey = 0
var aoe = -1

func _ready():
	anim_dir = ["RollEast", "RollNorth", "RollWest", "RollSouth"]
	dice_state = [randi()%6 + 1, 0]
	$OldFaces.frame = get_face_up() - 1
	$OldFaces.self_modulate = Color(1, 1, 1)
	
func _on_ControlDice_area_entered(area: Area2D) -> void:
	if area is Cannon:
		if get_face_up() == area.value:
			load_and_fire(area)
		else:
			$PenaltyAnimation.play("Wrong")
			slide((last_dir+2)%4)
			$OldFaces.self_modulate = Color(1, 1, 1)

func roll(direction : int) -> void:
	last_dir = direction
	dice_state = change_face(dice_state, direction)
	$NewFaces.frame = get_face_up() - 1
	$RollAnimation.play(anim_dir[direction])
	
	$NewFaces.show()
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12*1/0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	
	yield($MoveTween,"tween_completed")
	
func set_old_faces() -> void:
	$NewFaces.hide()
	$OldFaces.frame = get_face_up() - 1
	$OldFaces.position = Vector2(0,0)
	$OldFaces.scale = Vector2(1, 1)

func slide(direction : int) -> void:
	last_dir = direction
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")

func get_face_up() -> int : 
	return dice_state[0]

func set_dice_state(state) -> void:
	dice_state = state
	
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
