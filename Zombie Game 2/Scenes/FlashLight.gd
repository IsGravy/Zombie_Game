extends Light2D
func _ready():
	pass 
func _process(delta):
	position = lerp(position, get_global_mouse_position(), 0.5)
