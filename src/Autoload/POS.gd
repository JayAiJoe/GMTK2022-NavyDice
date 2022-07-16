extends Node

var tile_size := 64.0
var grid_rows := 6
var grid_columns := 6

var directions = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)]

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
