extends Area2D

class_name Cannon

signal fired

export var Projectile = preload("res://src/Items/Projectile.tscn")
export var row = 0
export var x_direction = 1

var value
var powerup

var deck = [1, 2 , 2, 3, 3, 3, 4, 4, 4, 5, 6]
var deck_temp = []

func _ready():
	randomize()
	randomdice()

func randomdice() -> void:
	if deck_temp.size() == 0:
		deck_temp = [] + deck
		deck_temp.shuffle()
	value = deck_temp.pop_front()
	$DicePreview.frame = value-1

func fire(coordinates : Vector2, dice_face : int) -> void:
	$AnimationPlayer.play("Firing")
	yield($AnimationPlayer, "animation_finished")
	var bullet = Projectile.instance()
	if x_direction == 1:
		bullet.target = Vector2(dice_face - 1, row - 1)
	else:
		bullet.target = Vector2(6 - dice_face, row - 1)
	bullet.speed *= x_direction
	add_child(bullet)
	emit_signal("fired")
	#randomdice()

