extends CharacterBody2D

enum ENEMY_STATE { PATROLLING, CHASING, SEARCHING }

@onready var nav_agent = $NavAgent
@onready var sprite_2d = $Sprite2D
@onready var label = $Label
@onready var player_detect = $PlayerDetect
@onready var ray_cast_2d = $PlayerDetect/RayCast2D
@onready var warning = $Warning
@onready var gasp_sound = $GaspSound
@onready var animation_player = $AnimationPlayer
@onready var shoot_timer = $ShootTimer

@export var patrol_points: NodePath

const BULLET = preload("res://scenes/bullet/bullet.tscn")

const FOV = {
	ENEMY_STATE.PATROLLING: 60.0,
	ENEMY_STATE.CHASING: 120.0,
	ENEMY_STATE.SEARCHING: 180.0,
}
const SPEED = {
	ENEMY_STATE.PATROLLING: 60.0,
	ENEMY_STATE.CHASING: 100.0,
	ENEMY_STATE.SEARCHING: 80.0,
}

var _waypoints: Array = []
var _current_wp: int = 0
var _player_ref: Player
var _state: ENEMY_STATE = ENEMY_STATE.PATROLLING


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	create_wp()
	_player_ref = get_tree().get_first_node_in_group("player")
	#call_deferred("set_physics_process", true)
	call_deferred("late_setup")


func late_setup():
	await get_tree().physics_frame
	await get_tree().create_timer(0.3).timeout
	call_deferred("set_physics_process", true)


func create_wp() -> void:
	for child in get_node(patrol_points).get_children():
		_waypoints.append(child.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	raycast_to_player()
	update_state()
	update_movement()
	update_navigation()
	set_label()


func get_fov_angle() -> float:
	var direction = global_position.direction_to(_player_ref.global_position)
	var dot_product = direction.dot(velocity.normalized())
	if dot_product >= -1.0 and dot_product <= 1.0:
		return rad_to_deg(acos(dot_product))
	return 0.0


func player_in_fov() -> bool:
	return get_fov_angle() < FOV[_state]


func raycast_to_player() -> void:
	player_detect.look_at(_player_ref.global_position)


func player_detected() -> bool: 
	var c = ray_cast_2d.get_collider()
	if c != null:
		return c.is_in_group("player")
	return false


func can_see_player() -> bool:
	return player_in_fov() and player_detected()


func update_navigation() -> void:
	if not nav_agent.is_navigation_finished():
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		sprite_2d.look_at(next_path_position)
		
		#velocity = global_position.direction_to(next_path_position) * SPEED[_state]
		var init_velocity = global_position.direction_to(next_path_position) * SPEED[_state]
		#move_and_slide()
		nav_agent.set_velocity(init_velocity)


func navigate_wp() -> void:
	if _current_wp >= len(_waypoints):
		_current_wp = 0
	nav_agent.target_position = _waypoints[_current_wp]
	_current_wp += 1


func process_patrolling() -> void:
	if nav_agent.is_navigation_finished():
		navigate_wp()


func process_chasing() -> void:
	set_nav_to_player()


func process_searching() -> void:
	if nav_agent.is_navigation_finished():
		set_state(ENEMY_STATE.PATROLLING)


func update_movement() -> void:
	match _state:
		ENEMY_STATE.PATROLLING:
			process_patrolling()
		ENEMY_STATE.SEARCHING:
			process_searching()
		ENEMY_STATE.CHASING:
			process_chasing()


func set_state(new_state: ENEMY_STATE) -> void:
	if new_state == _state:
		return
	
	if _state == ENEMY_STATE.SEARCHING:
		warning.hide()
	if new_state == ENEMY_STATE.SEARCHING:
		warning.show()
	elif new_state == ENEMY_STATE.CHASING:
		SoundManager.play_gasp(gasp_sound)
		animation_player.play("alert")
	elif new_state == ENEMY_STATE.PATROLLING:
		animation_player.play("RESET")
	
	_state = new_state


func update_state() -> void:
	var new_state = _state
	var can_see = can_see_player()
	if can_see:
		new_state = ENEMY_STATE.CHASING
	elif not can_see and new_state == ENEMY_STATE.CHASING:
		new_state = ENEMY_STATE.SEARCHING
	set_state(new_state)


func set_nav_to_player() -> void:
	nav_agent.target_position = _player_ref.global_position


func stop_action() -> void:
	set_physics_process(false)
	shoot_timer.stop()

func set_label():
	var s = "Done: %s\n" % nav_agent.is_navigation_finished()
	s += "Reached: %s\n" % nav_agent.is_target_reached()
	s += "Target: %s\n" % nav_agent.target_position
	s += "PlayerDetected: %s\n" % player_detected()
	s += "Is in FOV: %s\n" % player_in_fov()
	s += "FOV Angle: %.2f %s\n" % [get_fov_angle(), ENEMY_STATE.keys()[_state]]
	s += "Player in FOV: %s Speed: %s\n" % [player_in_fov(), SPEED[_state]]
	label.text = s


func shoot() -> void:
	var target = _player_ref.global_position
	var b = BULLET.instantiate()
	b.init(target, global_position)
	get_tree().root.add_child(b)
	SoundManager.play_laser(gasp_sound)


func _on_shoot_timer_timeout():
	if _state != ENEMY_STATE.CHASING:
		return
	shoot()


func _on_hit_area_body_entered(body):
	SignalManager.on_game_over.emit()


func _on_nav_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
