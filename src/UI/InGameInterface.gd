extends Control

onready var scene_tree := get_tree()
onready var overlay = $PauseOverlay
onready var menu = $PauseOverlay/Menu
onready var resume = $PauseOverlay/Menu/Resume
onready var interface_title = $PauseOverlay/Label

var paused := false setget set_paused
var ended := false

func _ready() -> void:
	menu.rect_size = Vector2(400, 160)
	resume.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		interface_title.text = "Paused"
		scene_tree.set_input_as_handled()
		

func set_paused(value : bool) -> void:
	paused = value
	scene_tree.paused = value
	overlay.visible = value


func _on_Resume_button_up() -> void:
	self.paused = false
	DjBeats.play_sound("button2", 2)
	

func end_game(ship_id : int) -> void:
	self.paused = true
	menu.rect_size = Vector2(400, 70)
	resume.visible = false
	if ship_id == 2:
		interface_title.text = "The WASD\nPirates win!"
	else:
		interface_title.text = "The ARRRRow\nPirates win!"
		



func _on_Exit_button_up() -> void:
	DjBeats.play_sound("button2", 2)
