extends CharacterBody2D

var maxhp = 20
var hp = 20
var atk = 2
var SPEED = 50
var pushback_strength  = 0.5
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0
var change_interval = 2  # Alle 2 Sekunden die Richtung ändern
var target
var target_direction
var dash_speed = 5
var is_dashing = false
@onready var progress_bar: ProgressBar = $ProgressBar2

func _ready() -> void:
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
	if !player_in_range and is_dashing:
		if time_since_last_change >= change_interval:
			is_dashing = false
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
		attck_player(body)
		#target_direction = target.position - position

func _on_search_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		
func attck_player(body):
	target = body
	if player_in_range and !is_dashing:
		is_dashing = true
		target_direction = (target.position - position)
		velocity = direction * SPEED * dash_speed 
		velocity.normalized()
		move_and_slide()
