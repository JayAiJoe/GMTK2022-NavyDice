extends Node2D

class_name Grid

enum tile_states{free, broken, blocked}

signal move

export var ControlDice = preload("res://src/Player/ControlDice.tscn")


var current_dice : ControlDice = null
var dice_position : Vector2 = Vector2(0, 0)

var _grid = []
var moving : bool = false



func _ready() -> void:
	for y in (POS.grid_rows):
		var row = []
		for x in range(POS.grid_columns):
			row.append(tile_states.free)
		_grid.append(row)
	spawn_dice()
		


#func _draw():
#	var draw = true
#	for x in range(POS.grid_columns):
#		for y in range(POS.grid_rows):
#			if (x + y) % 2 == 0:
#				draw_rect(Rect2(global_position.x + x * POS.tile_size + global_position.x, y * POS.tile_size + global_position.y, POS.tile_size, POS.tile_size), "#0000FF")


func move_dice(direction : int) -> void:
	var destination = dice_position + POS.directions[direction]
	if is_in_grid(destination) and get_tile_state(destination) != tile_states.blocked:
		yield(current_dice.roll(direction), "completed")
		dice_position = destination
	moving = false

func is_in_grid(coordinates : Vector2) -> bool:
	if coordinates.x >= 0 and coordinates.x < POS.grid_columns:
		if coordinates.y >=0 and coordinates.y < POS.grid_rows:
			return true
	return false

func get_tile_state(coordinates : Vector2) -> int:
	return _grid[coordinates.y][coordinates.x]


func spawn_dice() -> void:
	var dice = ControlDice.instance()
	add_child(dice)
	current_dice = dice