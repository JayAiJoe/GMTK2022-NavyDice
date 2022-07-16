extends Area2D

class_name Cannon

export var Projectile = preload("res://src/Items/Projectile.tscn")
export var row = 0
export var x_direction = 1

func fire(coordinates : Vector2) -> void:
	$AnimationPlayer.play("Firing")
	yield($AnimationPlayer, "animation_finished")
	var bullet = Projectile.instance()
	bullet.speed *= x_direction
	add_child(bullet)
