extends Node2D

var many_to_spawn: int 
var number_of_bats: int
var number_of_spiders: int
var number_of_wolves: int
const BAT = preload("res://Scenes/bat.tscn")
const SPIDER = preload("res://Scenes/spider.tscn")
const WOOD = preload("res://Scenes/wood.tscn")

@onready var wave_timer: Timer = $WaveTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_timer.start()
	
	#prepare_spawn("bat", 10,15)

func start_wave():
	Global.current_wave += 1  
	many_to_spawn = Global.current_wave 
	distribute_spawns()
	spawn_monsters()
	spawn_wood()
	wave_timer.start()
	print(Global.current_wave)

func spawn_monsters():
	#spawn bats
	var bat_spawn_points = [$SpawnPoints/BatSpawn1, $SpawnPoints/BatSpawn2, $SpawnPoints/BatSpawn3, $SpawnPoints/BatSpawn4, $SpawnPoints/BatSpawn5]
	for i in range(number_of_bats):
		var spawn_point = bat_spawn_points[i % bat_spawn_points.size()]  # Modulo damit man nicht über die Anzal der Spawnpoint micht überschritter wird
		var bat = BAT.instantiate()
		bat.position = spawn_point.position
		add_child(bat)
	
	#spawn spiders
	var spider_spawn_points = [$SpawnPoints/SpiderSpawn, $SpawnPoints/SpiderSpawn2, $SpawnPoints/SpiderSpawn3, $SpawnPoints/SpiderSpawn5, $SpawnPoints/SpiderSpawn4]
	for i in range(number_of_spiders):
		var spawn_point = spider_spawn_points[i % spider_spawn_points.size()]  # Modulo damit man nicht über die Anzal der Spawnpoint micht überschritter wird
		var spider = SPIDER.instantiate()
		spider.position = spawn_point.position
		add_child(spider)

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

#based on the wave, determine how many of each enemy to spawn
func distribute_spawns():
	#only spawns bats in first 3 waves
	if Global.current_wave <= 3:
		number_of_bats = many_to_spawn
		number_of_spiders = 0
		number_of_wolves = 0
	#spawns bats and spiders in waves 4-6
	elif Global.current_wave <= 6:
		number_of_bats = ceil(many_to_spawn / 2.0)
		number_of_spiders = floor(many_to_spawn / 2.0)
		number_of_wolves = 0

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
