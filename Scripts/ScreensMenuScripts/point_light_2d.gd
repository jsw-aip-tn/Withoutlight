extends PointLight2D

func _physics_process(delta: float) -> void:
	var vel : Vector2 = (get_global_mouse_position() - global_position).normalized() * 100

		
