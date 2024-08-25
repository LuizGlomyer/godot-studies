extends Control

@onready var score_label = $MC/ScoreLabel
@onready var exit_label = $MC/ExitLabel
@onready var time_label = $MC/TimeLabel
@onready var color_rect = $ColorRect
@onready var game_over_label = $ColorRect/GameOverLabel

var _time: float = 0.0
var _game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_show_exit.connect(on_show_exit)
	SignalManager.on_exit.connect(on_exit)
	SignalManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _game_over:
		_time += delta
		time_label.text = "%.1fs" % _time
	elif Input.is_action_just_pressed("press_space"):
		GameManager.load_main_scene()


func update_score(act: int, target:int) -> void:
	score_label.text = "%s / %s" % [act, target]


func on_game_over():
	if not _game_over:
		color_rect.show()
		_game_over = true
		game_over_label.text = "YOU LOSE! Press Space"


func on_show_exit() -> void:
	exit_label.show()


func on_exit() -> void:
	_game_over = true
	color_rect.show()
	game_over_label.text = "Well done! You took %.1f seconds" % _time
