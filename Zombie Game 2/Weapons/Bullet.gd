extends Area2D
class_name Bullet

export (int) var speed = 25

onready var kill_timer = $Timer

var direction := Vector2.ZERO

func _ready():
	kill_timer.start()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
