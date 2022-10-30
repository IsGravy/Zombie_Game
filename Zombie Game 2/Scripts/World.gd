extends Node2D

onready var player = $Player
onready var bullet_manager = $BulletManager

var z = load("res://Scenes/Zombie.tscn")

func _ready() -> void:
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	


func _on_Spawner_timeout():
	pass
	
