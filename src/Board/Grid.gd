extends Node2D

class_name Grid

enum tile_states {free, broken, blocked}
var tile_effects

signal move
signal hit(id, damage)

export var ControlDice = preload("res://src/Player/ControlDice.tscn")
export var FireTile = preload("res://src/Items/Fire.tscn")
export var Explosion = preload("res://src/Items/Explosion.tscn")

var current_dice  = null
var dice_position : Vector2 = Vector2(0, 0)

var _grid = []
var _grid_effects = []
export var grid_id := 1
var moving : bool = false

var loading_edge = 6

var consumables = {}
var effect_cooldowns = {}
var consumable_tiles = {}


func _ready() -> void:
	tile_effects = Databases.tile_effects
	randomize()
	for y in (POS.grid_rows):
		var row = []
		for x in range(POS.grid_columns):
			row.append(tile_states.free)
		_grid.append(row)
		_grid_effects.append([]+row)
	
	for cannon in $Armaments.get_children():
		cannon.connect("fired", self, "refresh_cannons")
	consumable_tiles = {Databases.tile_effects.fire : FireTile}
	spawn_dice()

func _on_RefillTimer_timeout() -> void:
	spawn_dice()

func _on_Grid_body_entered(body: Node) -> void:
	if body is Projectile:
		var damage = (body as Projectile).target
		if is_in_grid(damage):
			set_tile_state(damage, tile_states.broken)
		body.queue_free()

func start_refill_timer():
	$RefillTimer.start()

func spawn_dice() -> void:
	var dice = ControlDice.instance()
	dice.connect("consumed", self, "start_refill_timer")
	dice.connect("wrong", self, "wrong_dice")
	dice.connect("changed", $DiceVisualizer, "set_input")
	current_dice = dice
	add_child(dice)
	reset_dice()
	
func move_dice(direction : int) -> void:
	var destination = dice_position + POS.directions[direction]
	if is_in_grid(destination) and current_dice != null:
		var t_state = get_tile_state(destination)
		var t_effect = get_tile_effect(destination)
		if t_state == tile_states.free:
			yield(current_dice.roll(direction), "completed")
			dice_position = destination
			#check_tile_effect(t_effect, direction)
			yield(check_tile_effect(t_effect), "completed")
		print("NO")
		moving = false
			
	elif destination.x == loading_edge:
		yield(current_dice.slide(direction), "completed")
		
	else:
		print("ELSE")
		moving = false

func check_tile_effect(effect : int) -> void:
	var dir = current_dice.last_dir
	var dest = dice_position + POS.directions[dir]
	
	#reset
	current_dice.speed_mult = 1
	match effect:
		Databases.tile_effects.ice:
			if not is_in_grid(dest):
				yield(get_tree(), "idle_frame")
				return
			current_dice.speed_mult = 0.6
			yield(current_dice.slide(dir), "completed")
			dice_position = dest
			effect = get_tile_effect(dice_position)
			yield(check_tile_effect(effect), "completed")
			#slide diretso sa cannon dapat?
			
		Databases.tile_effects.slime:
			current_dice.speed_mult = 0.35
			
		Databases.tile_effects.fire:
			set_tile_effect(dice_position, tile_states.free)
			current_dice.consume()
			current_dice = null
	yield(get_tree(), "idle_frame")

func is_in_grid(coordinates : Vector2) -> bool:
	if coordinates.x >= 0 and coordinates.x < POS.grid_columns:
		if coordinates.y >=0 and coordinates.y < POS.grid_rows:
			return true
	return false

func wrong_dice():
	var undo_dir = (current_dice.last_dir+2)%4
	print(undo_dir)
	var destination = dice_position + POS.directions[undo_dir]
	print(destination)
	$PenaltyTimer.set_wait_time(0.5)
	$PenaltyTimer.start()
	yield($PenaltyTimer, "timeout")
	current_dice.wrong()
	yield(current_dice.slide(undo_dir), "completed")
	print("wrong")
	moving = false
	#dice_position = destination

func get_tile_state(coordinates : Vector2) -> int:
	return _grid[coordinates.y][coordinates.x]

func set_tile_state(coordinates : Vector2, state : int) -> void:
	_grid[coordinates.y][coordinates.x] = state
	$TileMap.set_cell(coordinates.x, coordinates.y, state)
	
func clear_tile_effect_visual(coordinates : Vector2):
	if coordinates in consumables:
		var node = consumables[coordinates]["node"]
		consumables.erase(coordinates)
		remove_child(node)
	$TileMap_Effects.set_cellv(coordinates, -1)
	$TileMap.set_cellv(coordinates, 2)
	
func get_tile_effect(coordinates : Vector2) -> int:
	return _grid_effects[coordinates.y][coordinates.x]
	
func set_tile_effect(coordinates : Vector2, effect : int) -> void:
	clear_tile_effect_visual(coordinates)
	if effect == Databases.tile_effects.fire:
		var new_fire = consumable_tiles[effect].instance()
		new_fire.position = POS.grid_to_global(coordinates,Vector2(32,32))
		consumables[coordinates] = {"node":new_fire, "effect":effect}
		add_child(new_fire)
	elif effect in [Databases.tile_effects.ice, Databases.tile_effects.slime]:
		effect_cooldowns[coordinates] = 2
		$TileMap_Effects.set_cellv(coordinates, effect-1)
	_grid_effects[coordinates.y][coordinates.x] = effect

func inflict_tile_effects(coordinates : Vector2, effect : int) -> void:	
	match effect:
		tile_effects.ice:
			for i in range(-1,2):
				set_tile_effect(coordinates + Vector2(i,0), effect)
				if i != 0:
					set_tile_effect(coordinates + Vector2(0,i), effect)
			
		tile_effects.slime:
			for i in range(-1,2):
				for j in range(-1,2):
					set_tile_effect(coordinates + Vector2(i,j), effect)
			
		tile_effects.fire:
			if randi()%2==0: #vertical
				for i in range(-1,2):
					set_tile_effect(coordinates + Vector2(i,0), effect)
			else:
				for i in range(-1,2):
					set_tile_effect(coordinates + Vector2(0,i), effect)
					
					
func receive_projectile(projectile : Projectile):
	emit_signal("hit", grid_id, projectile.damage_value)
	if projectile.effect != tile_effects.free:
		inflict_tile_effects(projectile.target_tile, projectile.effect)
	
func reset_dice():
	print("reset")
	moving = false
	if grid_id == 1:
		dice_position = Vector2(0,2)
	else:
		dice_position = Vector2(5,2)
	current_dice.global_position = POS.grid_to_global(dice_position, global_position)

func refresh_cannons():
	for cannon in $Armaments.get_children():
		(cannon as Cannon).randomdice()
	
	var to_be_erased = []
	for tile in effect_cooldowns:
		if effect_cooldowns[tile] == 0:
			to_be_erased.append(tile)
		else:
			effect_cooldowns[tile] -= 1
	for tile in to_be_erased:
		clear_tile_effect_visual(tile)
		effect_cooldowns.erase(tile)

#implement block and rotate tiles

	
