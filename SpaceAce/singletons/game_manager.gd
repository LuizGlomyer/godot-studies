extends Node


var level_scene: PackedScene = preload("res://level/level.tscn")
var main_scene: PackedScene = preload("res://main/main.tscn")


func _load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
 
 
func load_main_scene() -> void:
	call_deferred("_load_main_scene")
	# get_tree().change_scene_to_packed(main_scene)


func load_level_scene() -> void:
	get_tree().change_scene_to_packed(level_scene)
