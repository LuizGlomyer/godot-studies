extends Control


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("press_space"):
		GameManager.load_game_scene()

