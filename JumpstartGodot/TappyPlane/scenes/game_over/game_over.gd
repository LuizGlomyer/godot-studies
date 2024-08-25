extends Control

@onready var game_over_label = $GameOverLabel
@onready var space_label = $SpaceLabel
@onready var timer = $Timer
@onready var game_over_sound = $GameOverSound


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	SignalManager.on_plane_died.connect(on_plane_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if space_label.visible:
		if Input.is_action_just_pressed("fly"):
			GameManager.load_main_scene()


func on_plane_died() -> void:
	show()
	timer.start()
	game_over_sound.play()


func _on_timer_timeout():
	game_over_label.hide()
	space_label.show()
