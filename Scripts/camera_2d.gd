extends Camera2D

const DEAD_ZONE = 100.0  # Dead Zone in Pixeln
const CAMERA_SPEED = 5.0  # Geschwindigkeit der Kamerabewegung


	
func _process(delta: float) -> void:
	# Hole die Mausposition im globalen Raum
	var mouse_position = get_global_mouse_position()

	# Berechne die Distanz zwischen der Maus und der Kameraposition
	var distance = mouse_position - global_position

	# Überprüfe, ob die Maus außerhalb der Dead Zone ist
	if abs(distance.x) > DEAD_ZONE or abs(distance.y) > DEAD_ZONE:
		# Bewege die Kamera in Richtung der Mausposition
		var target = distance.normalized()
		global_position += target * CAMERA_SPEED * delta



#func _input(event:InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#var _target = event.position - get_viewport().get_mouse_position()
		#if _target.length() < Dead_Zone:
			#self.position = Vector2(0,0)
		#else:
			#self.position = _target.normalized() * (_target.length() - Dead_Zone)

		#Shader Code
