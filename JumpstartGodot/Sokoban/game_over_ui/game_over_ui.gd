extends Control


@onready var record_label = $MC/NP/MC/VBoxContainer/RecordLabel
@onready var moves_label = $MC/NP/MC/VBoxContainer/MovesLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_game() -> void:
	hide()
	record_label.hide()


func game_over(level: String, moves: int) -> void:
	show()
	moves_label.text = str(moves) + " MOVES TAKEN"
	if ScoreSync.score_is_new_best(level, moves):
		record_label.show()
