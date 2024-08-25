extends Control


@export var level_button_scene: PackedScene
@onready var h_box_container_levels = $VBoxContainer/HBoxContainerLevels


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_grid()


func create_level_button(ln: int) -> void:
	var new_level_button = level_button_scene.instantiate()
	h_box_container_levels.add_child(new_level_button)
	new_level_button.set_level_number(ln)


func setup_grid() -> void:
	for level in GameManager.LEVELS:
		create_level_button(level)
