extends Node2D

var many_to_spawn: int 
const BAT = preload("res://Scenes/bat.tscn")
#@onready var bat_spawn_1: Marker2D = $BatSpawn1
const WOOD = preload("res://Scenes/wood.tscn")

@onready var wave_timer: Timer = $WaveTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_timer.start()
	
	#prepare_spawn("bat", 10,15)

func start_wave():
	Global.current_wave += 1  
	many_to_spawn = Global.current_wave 
	spawn_monsters()
	spawn_wood()
	wave_timer.start()
	print(Global.current_wave)

func spawn_monsters():
	var bat_spawn_points = [$SpawnPoints/BatSpawn1, $SpawnPoints/BatSpawn2, $SpawnPoints/BatSpawn3, $SpawnPoints/BatSpawn4, $SpawnPoints/BatSpawn5]
	for i in range(many_to_spawn):
		var spawn_point = bat_spawn_points[i % bat_spawn_points.size()]  # Modulo damit man nicht über die Anzal der Spawnpoint micht überschritter wird
		var bat = BAT.instantiate()
		bat.position = spawn_point.position
		add_child(bat)
		
func spawn_wood():
	var wood_spawn_points = [$SpawnPoints/WoodSpawn]
	for i in range(many_to_spawn ):
		var spawn_point = wood_spawn_points[i % wood_spawn_points.size()] 
		var wood = WOOD.instantiate()
		wood.position = spawn_point.position
		add_child(wood)
		


func _on_wave_timer_timeout() -> void:
	wave_timer.stop()
	start_wave()


#func prepare_spawn(type, multiplier, mob_spawns):
	#var mob_amount = float(current_wave) * multiplier
	#var mob_wait_time: float = 2
	#var mob_spawn_rounds = mob_amount/mob_spawns
	#spawn_type(type, mob_spawn_rounds, mob_wait_time)
	
#func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	#if type == "bat":
		#var bat_spawn1 = $BatSpawn
		#var bat_spawn2 = $BatSpawn2
		#var bat_spawn3 = $BatSpawn3
		#var bat_spawn4 = $BatSpawn4
		#var bat_spawn5 = $BatSpawn5
		#if  mob_spawn_rounds >= 1:
			#for i in mob_spawn_rounds:
				#var bat1 = BAT.instantiate()
				#bat1.global_position = bat_spawn1.global_position
				#var bat2 = BAT.instantiate()
				#bat2.global_position = bat_spawn2.global_position
				#var bat3 = BAT.instantiate()
				#bat3.global_position = bat_spawn3.global_position
				#var bat4 = BAT.instantiate()
				#bat4.global_position = bat_spawn4.global_position
				#var bat5 = BAT.instantiate()
				#bat5.global_position = bat_spawn5.global_position
				#add_child(bat1)
				#add_child(bat2)
				#add_child(bat3)
				#add_child(bat4)
				#add_child(bat5)
				#print("spawn")
				#mob_spawn_rounds -= 1
				#await get_tree().create_timer(mob_wait_time).timeout
