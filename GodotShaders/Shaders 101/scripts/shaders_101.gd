extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	var TIME = Time.get_ticks_msec() / 1000.0
	# print("Time since game starteed: ", TIME)
	
	if Input.is_action_just_pressed("set_speed"):
		var new_speed = randf_range(1.0, 10.0)
		sprite_2d.material.set_shader_parameter("my_float", new_speed)
		print(sprite_2d.material.get_shader_parameter("my_float"))

	if Input.is_action_just_pressed("set_color"):
		var new_color = Vector4(randf(), randf(), randf(), 1)
		sprite_2d.material.set_shader_parameter("my_color", new_color)
		print(sprite_2d.material.get_shader_parameter("my_color"))
