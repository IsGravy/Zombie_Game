extends KinematicBody2D

class_name Player

signal player_fired_bullet(bullet, position, direction)
onready var Bullet = load("res://Weapons/Bullet.tscn")
#Health/Speed
var speed = 500
var health: int = 100
#May not need the signal
signal mag_empty

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var fire_cooldown = get_node("FireCooldown")
onready var animation_player = $AnimationPlayer
#Gun
export var Equipped_Gun = 2
#Fire Rate
func _ready():
	Get_Gun_Info()

func Get_Gun_Info():
	if Equipped_Gun == 1:
		Global.fire_rate = Global.pistol[1]
		Global.max_ammo = Global.pistol[2]
		Set_Values()
	if Equipped_Gun == 2:
		Global.fire_rate = Global.smg[1]
		Global.max_ammo = Global.smg[2]
		Set_Values()
#Set Values
func Set_Values():
		Global.current_ammo = Global.max_ammo
		fire_cooldown.set_wait_time(Global.fire_rate)
#Movement
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
	
#Shoot/Reload
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		shoot()
	if event.is_action_released("reload"):
		reload()
#Set Variables Based On Equipped Gun
func shoot():
#Check If U Can Shoot
	if Global.current_ammo != 0 and fire_cooldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		fire_cooldown.start()
		animation_player.play("Muzzle_Flash")
		Global.current_ammo -= 1

#Reload Functions
func reload():
	start_reload()
func start_reload():
	animation_player.play("Reload")
func _stop_reolad():
	Global.current_ammo = Global.max_ammo
	
# Slow down when pushing obj -- Doesnt work 100%
func _on_Area2D_body_entered(body):
	if body is RigidBody2D:
		if body.name == "R":
			speed = 100
			
func _on_Area2D_body_exited(body):
	speed = 500
