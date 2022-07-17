extends Grid

func _ready() -> void:
	loading_edge = -1
	POS.set_P2_origin(global_position)
	Databases.grids[2] = self

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if not moving:
			if event.is_action_pressed("P2_right"):
				moving = true
				move_dice(0)
			elif event.is_action_pressed("P2_up"):
				moving = true
				move_dice(1)
			elif event.is_action_pressed("P2_left"):
				moving = true
				move_dice(2)
			elif event.is_action_pressed("P2_down"):
				moving = true
				move_dice(3)
