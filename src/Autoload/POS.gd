extends Node

var tile_size := 64.0
var grid_rows := 6
var grid_columns := 6

var directions = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)]

var P1_origin
var P2_origin

func global_to_grid(global_pos : Vector2, origin : Vector2) -> Vector2:
	var temp = (global_pos - origin) / tile_size
	temp.x = ceil(temp.x)
	temp.y = ceil(temp.y)
	return temp - Vector2.ONE

func grid_to_global(grid_pos : Vector2, origin : Vector2) -> Vector2:
	var temp = (grid_pos * tile_size) + origin
	return temp
	
func is_in_grid(grid_pos : Vector2) -> bool:
	if grid_pos.x >= 0 and grid_pos.x < grid_columns:
		if grid_pos.y >= 0 and grid_pos.y < grid_rows:
			return true
	return false

func is_on_board(global_pos : Vector2, origin : Vector2) -> bool:
	var grid_pos = global_to_grid(global_pos, origin)
	return is_in_grid(grid_pos)
	
func flip_h_coordinates(coordinates : Vector2) -> Vector2:
	return Vector2(grid_columns-1, grid_rows-1) - coordinates

func get_P1_origin() -> Vector2:
	return P1_origin

func set_P1_origin(coordinates : Vector2) -> void:
	P1_origin = coordinates

func get_P2_origin() -> Vector2:
	return P2_origin

func set_P2_origin(coordinates : Vector2) -> void:
	P2_origin = coordinates
