extends CharacterBody2D

var maxhp = 20
var hp = 20
var atk = 2
var SPEED = 0.0
var pushback_strength  = 0.5
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0
var change_interval = 2  # Alle 2 Sekunden die Richtung ändern
var target
var target_direction
@onready var progress_bar: ProgressBar = $ProgressBar2

func _ready() -> void:
	SPEED += 50
	update_hpBar()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	movement(delta)
	
func enemy():
	pass
	
func update_hpBar():
	progress_bar.update_health(hp, maxhp)
	
func movement(delta: float):
	time_since_last_change += delta
	if player_in_range:
		target_direction = (target.position - position).normalized()
		velocity = direction * (SPEED * 3)
		
	else :
		if !player_in_range:
			if time_since_last_change >= change_interval:
				var angle = randf_range(0, 2 * PI)  # Zufälligen Winkel generieren
				direction = Vector2(cos(angle), sin(angle)) # Berechne Richtung
				time_since_last_change = 0
				velocity = direction * SPEED	
				velocity.normalized()
	move_and_slide()
	
func received_damaged(atk):
	hp = hp -  atk
	update_hpBar()
	if hp <= 0:
		queue_free()

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		target = body
		body.received_damaged(atk)
		body.pushback(position, pushback_strength)

func _on_search_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		target = body
		#target_direction = target.position - position

func _on_search_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
