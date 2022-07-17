extends Area2D

class_name Cannon

export var Projectile = preload("res://src/Items/Projectile.tscn")
export var row = 0
export var x_direction = 1

var value
var powerup

func _ready():
	randomdice()

func randomdice() -> void:
	value = randi()%6 + 1
	$DicePreview.frame = value-1

func fire(coordinates : Vector2, dice_face : int) -> void:
	$AnimationPlayer.play("Firing")
	yield($AnimationPlayer, "animation_finished")
	var target_tile = Vector2(randi()%4 + 1,randi()%4 + 1)
	var bullet = Projectile.instance()
	if x_direction == 1:
		bullet.target_coord = POS.grid_to_global(target_tile, POS.get_P2_origin())
		bullet.target_grid = 2
	else:
		bullet.target_coord = POS.grid_to_global(target_tile, POS.get_P1_origin())
		bullet.target_grid = 1
	add_child(bullet)
	
	randomdice()

