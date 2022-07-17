extends KinematicBody2D

class_name Projectile

var target_tile
var target_coord : Vector2 = Vector2(-1, -1)
var target_grid
var effect
var damage_value := 0

func _ready():
	$MoveTween.interpolate_property(self, "global_position", global_position, target_coord, 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MoveTween.start()
	yield($MoveTween, "tween_completed")
	Databases.grids[target_grid].receive_projectile(self)
	queue_free()
