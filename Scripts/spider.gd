extends CharacterBody2D

var maxhp = 20
var hp = 20
var atk = 2
@export var SPEED : float = 30
var pushback_strength  = 120
var knockback: Vector2 = Vector2.ZERO
var player_in_range = false
var direction = Vector2()
var time_since_last_change = 0.0
var change_interval = 2.0  # Alle 2 Sekunden die Richtung ändern
var target
var target_direction: Vector2 = Vector2.ZERO
var dash_speed = 2.0
var is_dashing = false
var is_alive = true
#@onready var player = get_node("/root/Game/Player")
@onready var progress_bar: ProgressBar = $ProgressBar2

func _ready() -> void:
	update_hpBar()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_alive:
		movement(delta)
	
func enemy():
	pass
	
func update_hpBar():
	progress_bar.update_health(hp, maxhp)
	
func movement(delta: float):
	#SPEED = 10.0
	time_since_last_change += delta
	if !player_in_range and !is_dashing:
		if time_since_last_change >= change_interval:
			var angle = randf_range(0, 2 * PI)  # Zufälligen Winkel generieren
			direction = Vector2(cos(angle), sin(angle)) # Berechne Richtung
			time_since_last_change = 0.0
			velocity = direction.normalized() * SPEED
	elif  player_in_range and is_dashing:
		target_direction = (target.global_position - global_position).normalized()
		velocity = target_direction * SPEED * dash_speed
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true # Move right
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false  # Move left
	
	velocity += knockback
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 0.7)

func received_damaged(dmg):
	hp = hp -  dmg
	update_hpBar()
	if hp <= 0:
		$AnimationPlayer.play("death")
		is_alive = false
	else:
		$AnimationPlayer.play("hurt")
		#var pushback_direction = (position - target_direction).normalized()
		#velocity = pushback_direction * -800.0
		#move_and_slide()

func pushback(pushback_direction: Vector2, strength):
	knockback += pushback_direction.normalized() * strength

func reset_animation():
	if player_in_range:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")

func _on_enemie_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") and is_alive:
		player_in_range = false
		is_dashing = false
		target = body
		body.received_damaged(atk)
		body.pushback(global_position.direction_to(body.global_position), pushback_strength)

func _on_search_area_body_entered(body: Node2D) -> void:
	if body.has_method("player") and is_alive:
		player_in_range = true
		is_dashing = true
		target = body
		$AnimationPlayer.play("walk")

		#attck_player(body)
		#target_direction = target.position - position

func _on_search_area_body_exited(body: Node2D) -> void:
	if body.has_method("player") and is_alive:
		player_in_range = false
		is_dashing = false
		$AnimationPlayer.play("idle")
		


		
#func attck_player(body):
#
	#if player_in_range and !is_dashing:
		#target_direction = (target.position - position).normalized()
		#velocity = target_direction * SPEED * dash_speed 
	#move_and_slide()
	#print("Attack Moving")
