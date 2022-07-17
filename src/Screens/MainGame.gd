extends Node2D

var max_health := 10
var P1_hp := 0.0
var P2_hp := 0.0

onready var war_bar = $UILayer/WarBar
onready var interface = $UILayer/InGameInterface


func _ready() -> void:
	$GridP1.connect("hit", self, "update_ships")
	$GridP2.connect("hit", self, "update_ships")
	
	reset_health()
	war_bar.set_value(0.5)

func update_ships(ship_id : int, damage : int) -> void:
	if ship_id == 1:
		P1_hp = max(0, P1_hp - damage)
		P2_hp = min(max_health, P2_hp + (damage / 2.0))
	else:
		P2_hp = max(0, P2_hp - damage)
		P1_hp = min(max_health, P1_hp + (damage / 2.0))
	
	var rat = calculate_ratio()
	var sig = sigmoid(rat)
	war_bar.set_value(sig)
	
	if P1_hp == 0:
		interface.end_game(1)
	elif P2_hp == 0:
		interface.end_game(2)
	
	print("Ratio " + str(rat) + " Sidmoig : " + str(sig))
	print("Ship 1: " + str(P1_hp) + " Ship 2 : " + str(P2_hp))

func reset_health() -> void:
	P1_hp = max_health
	P2_hp = max_health

func calculate_ratio() -> float:
	if P1_hp + P2_hp != 0:
		return P1_hp / (P1_hp + P2_hp)
	return 0.5

func sigmoid(x : float) -> float:
	x = x*8 -4
	return 1/(1+exp(-x))
