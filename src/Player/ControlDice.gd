extends Node2D

class_name ControlDice

signal consumed
signal wrong

var dice_state
var anim_dir
var last_dir

var speed_mult

#modifiers
var blocker = false
var gooey = 0
var icey = 0
var aoe = -1

func _ready():
	anim_dir = ["RollEast", "RollNorth", "RollWest", "RollSouth"]
	$OldFaces.self_modulate = Color(1, 1, 1)
	dice_state = [randi()%6 + 1, 0]
	$OldFaces.frame = get_face_up() - 1
	speed_mult = 1
	
func _on_ControlDice_area_entered(area: Area2D) -> void:
	if area is Cannon:
		if get_face_up() == area.value:
			load_and_fire(area)
		else:
			emit_signal("wrong")

func roll(direction : int) -> void:
	last_dir = direction
	dice_state = change_face(dice_state, direction)
	$NewFaces.frame = get_face_up() - 1
	$RollAnimation.playback_speed = speed_mult
	$RollAnimation.play(anim_dir[direction])
	
	$NewFaces.show()
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.15/speed_mult, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	
	yield($MoveTween,"tween_completed")
	
func set_old_faces() -> void:
	$RollAnimation.playback_speed = 1
	$NewFaces.hide()
	$OldFaces.frame = get_face_up() - 1
	$OldFaces.position = Vector2(0,0)
	$OldFaces.scale = Vector2(1, 1)

func slide(direction : int) -> void:
	last_dir = direction
	$MoveTween.interpolate_property(self, "global_position", global_position, global_position + POS.directions[direction] * POS.tile_size, 0.15/speed_mult, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")

func get_face_up() -> int : 
	return dice_state[0]

func set_dice_state(state) -> void:
	dice_state = state
	
func change_face(curr_state, direction : int):
	return Databases.next_dice_state[curr_state[0]][curr_state[1]][direction]
	
func load_and_fire(area : Area2D) -> void:
	if area is Cannon:
		(area as Cannon).fire(Vector2(get_face_up(), get_face_up()), get_face_up())
		consume()

func wrong() -> void:
	$PenaltyAnimation.play("Wrong")
	
func consume() -> void:
	emit_signal("consumed")
	queue_free()
