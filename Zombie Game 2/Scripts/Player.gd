extends KinematicBody2D

class_name Player

signal player_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet
export var speed = 500

var health: int = 100

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var fire_cooldown = get_node("FireCooldown")
onready var animation_player = $AnimationPlayer



func _ready():
	fire_cooldown.set_wait_time(Global.fire_rate)
	
func _physics_process(delta: float) -> void:
	var movement_directon := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		movement_directon.y = -1
	if Input.is_action_pressed("down"):
		movement_directon.y = 1
	if Input.is_action_pressed("left"):
		movement_directon.x = -1
	if Input.is_action_pressed("right"):
		movement_directon.x =  1
		
	movement_directon = movement_directon.normalized()
	move_and_slide(movement_directon * speed)
	
	look_at(get_global_mouse_position())
	
	
			
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		shoot()
		
func shoot():
	if fire_cooldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		fire_cooldown.start()
		animation_player.play("Muzzle_Flash")
		
func handle_hit():
	health -= 20
	print("player hit", health)

# Slow down when pushing obj
func _on_Area2D_body_entered(body):
	if body is RigidBody2D:
		if body.name == "R":
			speed = 100


func _on_Area2D_body_exited(body):
	speed = 500
