extends CharacterBody2D

var maxHp = 100
var hp = 100
var atk = 0
const SPEED = 160.0
var enemy_in_range = false
var atk_cooldown = true
var player_alive = true
var direction : Vector2
var facing : Vector2 = Vector2.LEFT
var range_attack_triggered : bool = false
var melee_attack_triggered : bool = false
var animation_player : AnimationPlayer 
var light_nearby = false
var torch_nearby: int

const TORCH = preload("res://Scenes/torch.tscn")
const arrow_path = preload("res://Scenes/arrow.tscn")
@onready var arrow_spawn_point: Node2D = $AnimatedSprite2D/arrowSpawnPoint
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $atk_cooldown
@onready var progress_bar: ProgressBar = $ProgressBar2

func _ready() -> void:
	update_hpBar()

func _physics_process(delta: float) -> void:
	movement()
	place_torch()
	
	if hp <= 0:
		player_alive = false

func player():
	pass

func movement():
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if facing != direction and direction != Vector2.ZERO:
		facing = direction
	if direction.length():
		direction = direction.normalized()
		velocity = direction * SPEED
		#look_at(position + direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		idle_animation()

	if !melee_attack_triggered && !range_attack_triggered:
			animation()
			move_and_slide()

func update_hpBar():
	progress_bar.update_health(hp, maxHp)
	

func place_torch():
	if Input.is_action_just_pressed("place_torch"):
		if (Global.wood_stack > 0):
			if !light_nearby && torch_nearby <= 0:
				var torch = TORCH.instantiate()
				Global.wood_stack -=1
				torch.position = position
				get_parent().add_child(torch)
		
func animation():
	# Wenn eine Bewegung stattfindet, wird die "run"-Animation abgespielt
	if direction.x != 0 :
		if direction.x > 0:
			animated_sprite.flip_h = false  # Blick nach rechts
			$AnimatedSprite2D/arrowSpawnPoint.position.x = 30
		else:
			animated_sprite.flip_h = true  # Blick nach links
			$AnimatedSprite2D/arrowSpawnPoint.position.x = -30
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

func fire(dir : Vector2):
	var arrow = arrow_path.instantiate()
	if range_attack_triggered:
		arrow.pos = $AnimatedSprite2D/arrowSpawnPoint.global_position
		arrow.rota = deg_to_rad((dir.x*90)-90) 
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
		body.received_damaged(atk)

func received_damaged(atk):
	hp = hp -  atk
	update_hpBar()
	if hp >= 0:
		player_alive = false
#
func pushback(enemy_position: Vector2, pushback_strength):
	var pushback_direction = (position - enemy_position)  
	velocity = pushback_direction * pushback_strength  
	move_and_slide() 
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = false
#
func enemy_attack():
	if enemy_in_range and atk_cooldown == true:
		return atk
#
func _on_atk_cooldown_timeout() -> void:
	melee_attack_triggered = false
	fire(facing)
	range_attack_triggered = false
	cooldown_timer.stop()
