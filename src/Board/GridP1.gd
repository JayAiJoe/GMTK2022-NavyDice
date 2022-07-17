extends Grid

func _ready() -> void:
	POS.set_P1_origin(global_position)
	Databases.grids[1] = self

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if not moving:
			if event.is_action_pressed("P1_right"):
				moving = true
				move_dice(0)
			elif event.is_action_pressed("P1_up"):
				moving = true
				move_dice(1)
			elif event.is_action_pressed("P1_left"):
				moving = true
				move_dice(2)
			elif event.is_action_pressed("P1_down"):
				moving = true
				move_dice(3)
