extends Node2D

@onready var play_button = $CanvasLayer/MarginContainer/VBoxContainer/PlayButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	GameManager.load_level_scene()


func _on_exit_button_pressed():
	get_tree().quit()
