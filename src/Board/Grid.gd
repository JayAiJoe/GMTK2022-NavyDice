extends Node2D

class_name Grid

enum tile_states{free, broken, blocked}
enum equip_type{free, fill, blocked, trigger, push}

signal move

export var ControlDice = preload("res://src/Player/ControlDice.tscn")

var current_dice  = null
var dice_position : Vector2 = Vector2(0, 0)

var _grid = []
var moving : bool = false

var loading_edge = 6

#========Statuses and Effects
var _equip_grid = []
var _equip_id_grid = []
var statuses = []
var equipments = []

func _ready() -> void:
	for y in (POS.grid_rows):
		var row = []
		for x in range(POS.grid_columns):
			row.append(tile_states.free)
		_grid.append(row)
		_equip_grid.append(row)
		
		row = []
		for x in range(POS.grid_columns):
			row.append(-1)
		_equip_id_grid.append(row)
		
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
	if is_in_grid(destination) and current_dice != null:
		var t_state = get_tile_state(destination)
		if t_state == tile_states.free:
			yield(current_dice.roll(direction), "completed")
			dice_position = destination
			
			#check equip triggers
			if get_equip_type(destination) == equip_type.trigger:
				equipments[get_equip_id(destination)]["number"] += 1
			
		elif t_state == tile_states.broken:
			yield(current_dice.roll(direction), "completed")
			set_tile_state(destination, tile_states.free)
			current_dice.consume() #fall animation
			current_dice = null
			
			#check fill equips
			if get_equip_type(destination) == equip_type.fill:
				equipments[get_equip_id(destination)]["number"] += 1
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
	
func get_equip_type(coordinates : Vector2) -> int:
	return _equip_grid[coordinates.y][coordinates.x]
	
func set_equip_type(coordinates : Vector2, state : int) -> void:
	_equip_grid[coordinates.y][coordinates.x] = state
	
func get_equip_id(coordinates : Vector2) -> int:
	return _equip_id_grid[coordinates.y][coordinates.x]
	
func set_equip_id(coordinates : Vector2, state : int) -> void:
	_equip_id_grid[coordinates.y][coordinates.x] = state

func reset_dice():
	moving = false
	dice_position = Vector2.ZERO

#=================EQUIPMENTS===============
func add_equipment(equipment_index, topleft : Vector2, ori : int):
	var i = len(equipments)
	equipments.append({ "type": equipment_index,
						"number": 0})
	var e = Databases.equipment_db[equipment_index]
	for col in range(len(e)):
		for row in range(len(e)):
			set_equip_type(topleft + Vector2(col,row),  e[col][row])
			set_equip_id(topleft + Vector2(col,row), i)

func activate_equipment(index : int):
	var equip = equipments[index]
	match equip["type"]:
		0:
			current_dice.slide(equip["number"])
		1:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
