extends KinematicBody2D

class_name Projectile

var target : Vector2 = Vector2(-1, -1)
var speed := 700.0
var acceleration := 0.0 #25.0
var max_speed := 1500.0

func set_target(coordinates : Vector2) -> void:
	target = coordinates

func _physics_process(delta: float) -> void:
	position.x += speed * delta
	speed += acceleration
