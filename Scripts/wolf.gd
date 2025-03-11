extends CharacterBody2D

var maxhp = 50
var hp = 50
var atk = 4
@export var SPEED : float = 30
var pushback_strength  = 0.5
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0
var change_interval = 2  # Alle 2 Sekunden die Richtung ändern
var target
var target_direction: Vector2 = Vector2.ZERO
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
	if player_in_range:
		var target_direction = target.position - position  # Vektor vom Gegner zum Spieler
		direction = target_direction.normalized()
	else:
		if time_since_last_change >= change_interval:
			var angle = randf_range(0, 2 * PI)  # Zufälligen Winkel generieren
			direction = Vector2(cos(angle), sin(angle))  # Berechne Richtung
			time_since_last_change = 0		
	velocity = direction * SPEED 
	move_and_slide()
	
func received_damaged(atk):
	hp = hp -  atk
	if hp <= 0:
		print("Dead")
		queue_free()

func _on_enemie_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		target = body
		body.received_damaged(atk)
		print(hp)

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_search_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_search_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
