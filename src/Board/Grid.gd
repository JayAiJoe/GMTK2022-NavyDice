extends Node2D

class_name Grid

enum tile_states{free, broken, blocked}

signal move

export var ControlDice = preload("res://src/Player/ControlDice.tscn")

var current_dice  = null
var dice_position : Vector2 = Vector2(0, 0)

var _grid = []
var moving : bool = false

var loading_edge = 6

func _ready() -> void:
	for y in (POS.grid_rows):
		var row = []
		for x in range(POS.grid_columns):
			row.append(tile_states.free)
		_grid.append(row)
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
	reset_dice()
	var dice = ControlDice.instance()
	dice.connect("consumed", self, "start_refill_timer")
	current_dice = dice
	add_child(dice)
	

func move_dice(direction : int) -> void:
	var destination = dice_position + POS.directions[direction]
	if is_in_grid(destination):
		if get_tile_state(destination) != tile_states.blocked:
			yield(current_dice.roll(direction), "completed")
			dice_position = destination
	elif destination.x == loading_edge:
		yield(current_dice.slide(direction), "completed")
		dice_position = destination
	moving = false

func is_in_grid(coordinates : Vector2) -> bool:
	if coordinates.x >= 0 and coordinates.x < POS.grid_columns:
		if coordinates.y >=0 and coordinates.y < POS.grid_rows:
			return true
	return false

func get_tile_state(coordinates : Vector2) -> int:
	return _grid[coordinates.y][coordinates.x]

func set_tile_state(coordinates : Vector2, state : int) -> void:
	_grid[coordinates.y][coordinates.x] = state
	$TileMap.set_cell(coordinates.x, coordinates.y, state)

func reset_dice():
	moving = false
	dice_position = Vector2.ZERO





