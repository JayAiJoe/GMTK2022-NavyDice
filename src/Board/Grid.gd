extends Node2D

class_name Grid

enum tile_states {free, broken, blocked}
var tile_effects

signal move
signal hit(id, damage)

export var ControlDice = preload("res://src/Player/ControlDice.tscn")

var current_dice  = null
var dice_position : Vector2 = Vector2(0, 0)

var _grid = []
var _grid_effects = []
var grid_id := 1
var moving : bool = false

var loading_edge = 6


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
	current_dice = dice
	add_child(dice)
	reset_dice()
	
func move_dice(direction : int) -> void:
	var destination = dice_position + POS.directions[direction]
	if is_in_grid(destination) and current_dice != null:
		var t_state = get_tile_state(destination)
		if t_state == tile_states.free:
			yield(current_dice.roll(direction), "completed")
			dice_position = destination
			
		elif t_state == tile_states.broken:
			yield(current_dice.roll(direction), "completed")
			set_tile_state(destination, tile_states.free)
			current_dice.consume() #fall animation
			current_dice = null
		moving = false
			
	elif destination.x == loading_edge:
		yield(current_dice.slide(direction), "completed")
	
	else:
		moving = false

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
	moving = false
	#dice_position = destination

func get_tile_state(coordinates : Vector2) -> int:
	return _grid[coordinates.y][coordinates.x]

func set_tile_state(coordinates : Vector2, state : int) -> void:
	_grid[coordinates.y][coordinates.x] = state
	$TileMap.set_cell(coordinates.x, coordinates.y, state)
	
func get_tile_effects(coordinates : Vector2) -> int:
	return _grid_effects[coordinates.y][coordinates.x]
	
func set_tile_effects(coordinates : Vector2, effect : int) -> void:
	_grid_effects[coordinates.y][coordinates.x] = effect
	$TileMap_Effects.set_cellv(coordinates, effect-1)
	
func inflict_tile_effects(coordinates : Vector2, effect : int) -> void:
	match effect:
		tile_effects.ice:
			for i in range(-1,2):
				set_tile_effects(coordinates + Vector2(i,0), effect)
				set_tile_effects(coordinates + Vector2(0,i), effect)
			
		tile_effects.slime:
			for i in range(-1,2):
				for j in range(-1,2):
					set_tile_effects(coordinates + Vector2(i,j), effect)
			
		tile_effects.fire:
			if randi()%2==0: #vertical
				for i in range(-1,2):
					set_tile_effects(coordinates + Vector2(i,0), effect)
			else:
				for i in range(-1,2):
					set_tile_effects(coordinates + Vector2(0,i), effect)
	
func receive_projectile(projectile : Projectile):
	emit_signal("hit", grid_id, projectile.damage_value)
	if projectile.effect != tile_effects.free:
		inflict_tile_effects(projectile.target_tile, projectile.effect)
	
func reset_dice():
	moving = false
	dice_position = Vector2.ZERO

func refresh_cannons():
	for cannon in $Armaments.get_children():
		(cannon as Cannon).randomdice()
