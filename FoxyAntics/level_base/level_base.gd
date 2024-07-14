extends Node2D


@onready var player_cam = $PlayerCam
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.time_scale = 1
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_cam.position = player.position
	
	#if Input.is_action_just_pressed("left"):
		#GameManager.load_main_scene()
		#
	#if Input.is_action_just_pressed("right"):
		#GameManager.load_next_level_scene()
	
