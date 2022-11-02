extends KinematicBody2D

var health: int = 100

var _velocity := Vector2.ZERO

onready var path_to_player = NodePath("/root/World/Player")
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _player := get_tree().current_scene.get_node(path_to_player)
onready var _timer = $Timer
onready var _sprite: Sprite = $Zombie_Sprite

func _ready():
	_update_path()
	_timer.connect("timeout", self, "_update_path")
	
func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		return
	
	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * 500.0
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	
	_velocity = move_and_slide(_velocity)
	_sprite.rotation = _velocity.angle()
	
func _update_path() -> void:
	_agent.set_target_location(_player.global_position)
	
func handle_hit():
	health -= 20
	if health <= 0:
		queue_free()
