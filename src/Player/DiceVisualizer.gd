extends Node2D

func set_input(dice_state : Array) -> void:
	$Right.frame = Databases.next_dice_state[dice_state[0]][dice_state[1]][0][0] - 1 
	$Up.frame = Databases.next_dice_state[dice_state[0]][dice_state[1]][1][0] - 1
	$Left.frame = Databases.next_dice_state[dice_state[0]][dice_state[1]][2][0] - 1
	$Down.frame = Databases.next_dice_state[dice_state[0]][dice_state[1]][3][0] - 1
