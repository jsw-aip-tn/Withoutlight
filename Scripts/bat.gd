extends CharacterBody2D

var maxhp = 20
var hp = 20
var atk = 2
@export var SPEED : float = 40
var pushback_strength  = 100
var knockback: Vector2 = Vector2.ZERO
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0
var change_interval = 2  # Alle 2 Sekunden die Richtung ändern
var target
var target_direction: Vector2 = Vector2.ZERO
var dash_speed = 2.0
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
	if !player_in_range and !is_dashing:
		if time_since_last_change >= change_interval:
			var angle = randf_range(0, 2 * PI)  # Zufälligen Winkel generieren
			direction = Vector2(cos(angle), sin(angle)) # Berechne Richtung
			time_since_last_change = 0
			velocity = direction.normalized() * SPEED
	elif  player_in_range and is_dashing:
		is_dashing = true
		target_direction = (target.global_position - global_position).normalized()
		velocity = target_direction * SPEED * dash_speed
	
	velocity += knockback
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 0.6)
	
func received_damaged(dmg):
	hp = hp -  dmg
	update_hpBar()
	if hp <= 0:
		queue_free()

func pushback(pushback_direction: Vector2, strength):
	knockback += pushback_direction.normalized() * strength

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		target = body
		body.received_damaged(atk)
		body.pushback(global_position.direction_to(body.global_position), pushback_strength)
		player_in_range = false
		is_dashing = false
		$AttackCooldownTimer.start()

func _on_search_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		is_dashing = true
		target = body


func _on_search_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		is_dashing = false
		


func _on_attack_cooldown_timer_timeout() -> void:
	for body in $search_area.get_overlapping_bodies():
		if body.has_method("player"):
			player_in_range = true
			is_dashing = true
			return
