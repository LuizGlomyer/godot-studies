extends Node2D

@onready var score_sound = $ScoreSound

var _has_plane_died: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_plane_died.connect(on_plane_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * GameManager.SCROLL_SPEED


func on_plane_died() -> void:
	set_process(false)
	_has_plane_died = true


func _on_screen_exited():
	queue_free()


func _on_laser_body_exited(body):
	if !_has_plane_died && body.is_in_group(GameManager.GROUP_PLAYER):
		ScoreManager.increment_score()
		score_sound.play()


func _on_pipe_body_entered(body):
	if body.is_in_group(GameManager.GROUP_PLAYER):
		if body.has_method("die"):
			body.die()
