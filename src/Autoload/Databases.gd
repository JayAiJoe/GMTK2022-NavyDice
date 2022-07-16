extends Node

var next_dice_state
var equipment_db

func _ready():
	next_dice_state = {
		1: {0:[[4,0],[2,0],[3,0],[5,0]],
			1:[[5,1],[4,1],[2,1],[3,1]],
			2:[[3,2],[5,2],[4,2],[2,2]],
			3:[[2,3],[3,3],[5,3],[4,3]]},
			
		2: {0:[[4,1],[6,0],[3,3],[1,0]],
			1:[[1,1],[4,2],[6,1],[3,0]],
			2:[[3,1],[1,2],[4,3],[6,2]],
			3:[[6,3],[3,2],[1,3],[4,0]]},
			
		3: {0:[[1,0],[2,1],[6,2],[5,3]],
			1:[[5,0],[1,1],[2,2],[6,3]],
			2:[[6,0],[5,1],[1,2],[2,3]],
			3:[[2,0],[6,1],[5,2],[1,3]]},
		
		4: {0:[[6,2],[2,3],[1,0],[5,1]],
			1:[[5,2],[6,3],[2,0],[1,1]],
			2:[[1,2],[5,3],[6,0],[2,1]],
			3:[[2,2],[1,3],[5,0],[6,1]]},
		
		5: {0:[[4,3],[1,0],[3,1],[6,0]],
			1:[[6,1],[4,0],[1,1],[3,2]],
			2:[[3,3],[6,2],[4,1],[1,2]],
			3:[[1,3],[3,0],[6,3],[4,2]]},
			
		6: {0:[[4,2],[5,0],[3,2],[2,0]],
			1:[[2,1],[4,3],[5,1],[3,3]],
			2:[[3,0],[2,2],[4,0],[5,2]],
			3:[[5,3],[3,1],[2,3],[4,1]]},
	}
	
	#=======================EQUIPMENTS==================
	equipment_db = {
		0:[],
		1:[],
		2:[],
		3:[],
		4:[],
		5:[],
		6:[],
		7:[]
	}
