extends CharacterBody2D

var hp = 20
var atk = 2
const SPEED = 80.0
var player_in_range = false
var direction = Vector2()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement()
	
	
func enemy():
	pass
	
func movement():
	if !player_in_range:
		var angle = randf_range(0, 2 * 3)  # Zufälligen Winkel generieren
		direction = Vector2(cos(angle), sin(angle))  # Berechne Richtung
		velocity = direction * SPEED
		#position += direction * SPEED 
		move_and_slide()
	
func received_damaged(atk):
	hp = hp -  atk
	print(hp)
	if hp <= 0:
		queue_free()

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.received_damaged(atk)

func _on_enemie_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
