extends Area2D

class_name Cannon

signal fired

export var Projectile = preload("res://src/Items/Projectile.tscn")
export var row = 0
export var x_direction = 1

var value
var powerup
var target_tile

var deck = [1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 6]
var deck_temp = []

func _ready():
	randomize()
	randomdice()
	$Cannon.position.x = 32 - x_direction * 32

func randomdice() -> void:
	if deck_temp.size() == 0:
		deck_temp = [] + deck
		deck_temp.shuffle()
	value = deck_temp.pop_front()
	$DicePreview.frame = value-1
	target_tile = Vector2(randi()%6,randi()%6)
	
	powerup = Databases.tile_effects.free
	match value:
		1:
			powerup = Databases.tile_effects.fire
		2:
			powerup = Databases.tile_effects.ice
			if randi()%2==0:
				powerup = Databases.tile_effects.slime
		3:
			powerup = Databases.tile_effects.free
			if randi()%10<5:
				powerup = Databases.tile_effects.ice
				if randi()%2==0:
					powerup = Databases.tile_effects.slime
	
	var c = Color(1, 1, 1)
	match powerup:
		Databases.tile_effects.fire:
			c = Color(0.984314, 0.494118, 0.137255)
			target_tile = Vector2(randi()%4 + 1,randi()%4 + 1)
		Databases.tile_effects.ice:
			c = Color(0.443137, 0.713726, 0.811765)
			target_tile = Vector2(randi()%2 + 3,randi()%4 + 1)
		Databases.tile_effects.slime:
			c = Color(0.337255, 0.509804, 0.372549)
			target_tile = Vector2(randi()%2 + 1,randi()%4 + 1)
	$DicePreview.self_modulate = c

func fire(coordinates : Vector2, dice_face : int) -> void:
	$AnimationPlayer.play("Firing")
	yield($AnimationPlayer, "animation_finished")
	DjBeats.play_sound("cannon", 2)
	var bullet = Projectile.instance()
	bullet.damage_value = dice_face
	bullet.effect = powerup
	bullet.target_tile = target_tile
	if x_direction == 1:
		bullet.target_coord = POS.grid_to_global(target_tile, POS.get_P2_origin())
		bullet.target_grid = 2
	else:
		bullet.target_coord = POS.grid_to_global(target_tile, POS.get_P1_origin())
		bullet.target_grid = 1
	add_child(bullet)
	emit_signal("fired")

