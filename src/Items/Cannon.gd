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
	$Cannon.position.x = 32 - x_direction * 32

func randomdice() -> void:
	if deck_temp.size() == 0:
		deck_temp = [] + deck
		deck_temp.shuffle()
	value = deck_temp.pop_front()
	$DicePreview.frame = value-1
	
	powerup = Databases.tile_effects.free
	match value:
		1:
			powerup = Databases.tile_effects.fire
		3:
			powerup = Databases.tile_effects.free
			if randi()%10<3:
				continue #roll for what powerup
		2:
			powerup = Databases.tile_effects.ice
			if randi()%2==0:
				powerup = Databases.tile_effects.slime
			

func fire(coordinates : Vector2, dice_face : int) -> void:
	$AnimationPlayer.play("Firing")
	yield($AnimationPlayer, "animation_finished")
	DjBeats.play_sound("cannon", 2)
	var target_tile = Vector2(randi()%4 + 1,randi()%4 + 1)
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

