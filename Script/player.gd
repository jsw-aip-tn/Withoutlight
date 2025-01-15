extends CharacterBody2D

var hp = 50
var atk = 10
const SPEED = 160.0
var enemy_in_range = false
var atk_cooldown = true
var player_alive = true

const arrow_path = preload("res://Szene/character_body_2d.tscn")
@onready var arrow_spawn_point: Node2D = $AnimatedSprite2D/arrowSpawnPoint


var range_attack_triggered : bool = false
var melee_attack_triggered : bool = false
var animation_player : AnimationPlayer 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $atk_cooldown

func _physics_process(delta: float) -> void:
	movement()
	
	#enemy_attack()
	
	if hp <= 0:
		player_alive = false

func player():
	pass

func movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length():
		direction = direction.normalized()
		velocity = direction * SPEED
		#look_at(position + direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		idle_animation()
	animation(direction)
	move_and_slide()

func animation(direction: Vector2):
	# Wenn eine Bewegung stattfindet, wird die "run"-Animation abgespielt
	if direction.x != 0 :
		if direction.x > 0:
			animated_sprite.flip_h = false  # Blick nach rechts
			$AnimatedSprite2D/arrowSpawnPoint.position.x = 30
			$AnimatedSprite2D/arrowSpawnPoint.rotation = 3.14
		else:
			animated_sprite.flip_h = true  # Blick nach links
			$AnimatedSprite2D/arrowSpawnPoint.position.x = -30
			$AnimatedSprite2D/arrowSpawnPoint.rotation = 3.14
		if not animated_sprite.is_playing() or animated_sprite.animation != "run":
			animated_sprite.play("run")  # Abspielen der Lauf-Animation
#Bewegung nach Oben
	if direction.y != 0:
		if not animated_sprite.is_playing() or animated_sprite.animation != "run":
			animated_sprite.play("run")
	# Melee-Angriff Animation
	if Input.is_action_just_pressed("mele_atk") and not melee_attack_triggered:
		melee_attack_triggered = true
		if not animated_sprite.is_playing() or animated_sprite.animation != "mele_atk":
			animated_sprite.play("mele_atk")  # Abspielen der Angriff-Animation
		cooldown_timer.start()

	# Range-Angriff Animation
	if Input.is_action_just_pressed("range_atk") and not range_attack_triggered:
		range_attack_triggered = true
		if not animated_sprite.is_playing() or animated_sprite.animation != "range_atk":
			animated_sprite.play("range_atk")  # Abspielen der Fernkampf-Animation
		cooldown_timer.start()

func fire():
	var arrow = arrow_path.instantiate()
	if range_attack_triggered:
		arrow.pos = $AnimatedSprite2D/arrowSpawnPoint.global_position
		arrow.rota  = $AnimatedSprite2D/arrowSpawnPoint.global_rotation
		get_parent().add_child(arrow)
	
# Funktion für Idle-Animation, wenn keine Eingabe erfolgt
func idle_animation():
	# Idle-Animation wird nur abgespielt, wenn keine Angriffsanimation läuft
	if animated_sprite.is_playing() and (animated_sprite.animation == "mele_atk" or animated_sprite.animation == "range_atk"):
		return  # Verhindern, dass idle die Angriffsanimation überschreibt

	# Wenn keine Angriffsanimation läuft, spiele idle ab
	if not animated_sprite.is_playing() or animated_sprite.animation != "idle":
		animated_sprite.play("idle")  # Abspielen der Idle-Animation
		
		
		
		
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true
		received_damaged(body)


func received_damaged(enemy):
	hp = hp -  enemy.get_damage()
	if hp >= 0:
		player_alive = false
#
#
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = false
#
#
func enemy_attack():
	if enemy_in_range and atk_cooldown == true:
		return atk
#
#
func _on_atk_cooldown_timeout() -> void:
	melee_attack_triggered = false
	fire()
	range_attack_triggered = false
	cooldown_timer.stop()
	#atk_cooldown = true
