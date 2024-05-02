extends Node2D

signal auto_kill_enabled

#autokill enabled needs to be done in a different manner
#autokill is handled in a singleton
var ACOLYTE = preload("res://NewGame/acolyte.tscn").instantiate()
var minions = []
var auto_kill_timer: float

@onready var spawning_area: Node = get_node("/root/NewGame/spawning_area")

#new Acolytes
@export var acolytes_spawned: int = 0

func _ready():
	spawning_area.connect("spawn_basic_minion", spawn_minion)
	auto_kill_timer = GameManager.auto_kill_base_timer
	LowerBar.connect("all_kill_clear_list", all_kill_clear_list)
	#new_game.connect("show_me_coins", spawn_coin)

func _physics_process(delta):
	#pressing A
	if Input.is_action_just_pressed("auto_kill"): #this needs to be connected to the UI
		all_kill_clear_list() 
		emit_signal("auto_kill_enabled") # rework this into > kill all acolytes
	
	if Input.is_action_just_pressed("kill"): #press K
		kill_one_acolyte_only()
	
	#when auto kill is purchased
	if GameManager.auto_kill_acolytes:
		auto_kill_timer -= delta
		if auto_kill_timer <= 0:
			kill_one_acolyte_only()
			auto_kill_timer = GameManager.auto_kill_base_timer

func spawn_minion():
	spawn_acolyte(GameManager.acolytes_spawn_at_one_time)

func spawn_acolyte(count: int):
	for i in range(count):
		var new_acolyte = preload("res://NewGame/acolyte.tscn").instantiate()
		%PathToSpawn.progress_ratio = randf()
		new_acolyte.global_position = %PathToSpawn.global_position
		add_child(new_acolyte)
		acolytes_spawned += 1 #count all spawned acolytes
		GameManager.current_minion_count += 1
		minions.append(new_acolyte) #add minion to the list

func spawn_coin():
	var new_coin = preload("res://Scenes/coin_animation.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_coin.global_position = %PathFollow2D.global_position
	add_child(new_coin)

func kill_one_acolyte_only():
	if minions.size() > 0:
		var index = randi() % minions.size()
		var minion_to_kill = minions[index]
		minions.remove_at(index)
		minion_to_kill.die_now()

func clicked_minion(acolyte):
	minions.erase(acolyte)

func all_kill_clear_list():
	minions.clear()

