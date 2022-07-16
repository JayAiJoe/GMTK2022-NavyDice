extends Area2D

class_name Cannon

export var Projectile = preload("res://src/Items/Projectile.tscn")
export var row = 0
export var x_direction = 1

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
