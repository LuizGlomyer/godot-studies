extends CanvasLayer


@onready var label_high_score = $VBoxContainer/LabelHighScore


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	label_high_score.text = "Highscore: " + str(ScoreManager.get_highscore())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()
