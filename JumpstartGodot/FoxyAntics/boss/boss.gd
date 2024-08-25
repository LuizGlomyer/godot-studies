extends Node2D


@onready var animation_tree = $AnimationTree
@onready var visual = $Visual
@onready var hit_box = $Visual/HitBox

@export var lives: int = 2
@export var points: int = 5

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"
const HIT_CONDITION: String = "parameters/conditions/on_hit"

var _invincible: bool = false
var _has_triggered: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func tween_hit() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1.0)


func reduce_lives() -> void:
	lives -= 1
	print("reduce_lives:", lives)
	if lives <= 0:
		SignalManager.on_boss_killed.emit(points)
		set_process(false)
		queue_free()


func set_invincible(value: bool) -> void:
	print("set_invincible boss:", value)
	_invincible = value
	animation_tree[HIT_CONDITION] = value


func take_damage() -> void:
	if not _has_triggered:
		return
	
	if _invincible:
		return
	
	set_invincible(true)
	tween_hit()
	reduce_lives()


func _on_trigger_area_entered(_area):
	if not animation_tree[TRIGGER_CONDITION]:
		animation_tree[TRIGGER_CONDITION] = true
		_has_triggered = true
		hit_box.collision_layer = 4 # Collision Layer 3. Bit 2, value 4


func _on_hit_box_area_entered(_area):
	take_damage()
