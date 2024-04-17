extends Node2D

##description of the game

##defeat other summoners with your army and show others that you are the best one
#click on summoning area in order to summon your accolytes

#send your acollytes to work in order to gain mana over time

#sacrifice your acollytes, the more you sacrifice, the more mana you can get
#in the sacrifice area you can upgrade your abilities

#send your acollytes to barracks in order to be ready to face your oponents
#there is a timer of next fight, make sure to have some acollytes ready for war

##TODO
##code wise:
# Gameloop is ready: there are 4 different enemies
# if there is a time, add updates to the fight "scene" 
# and test how the game generally works
#
# create new entry scene with transition into the GAME scene
#
#
#POLISH
# make clean UI
# hover over texts
##TODO
##art wise
# tileset
# stations with animations - SPAWN/WORK/BARRACKS/SACRIFICE
# animate accolytes
# thumbnail art + name of the game
# effects - death/summon/some cool area effects(bubbles and such)
# upgrade icons
# mana icon/+1 mana up icon/
##TODO
##music and clicking effects/death/summon

#BATTLE section
var battle_won: bool = false
var enemy_minions: int
var enemy_name: String
var randNumber: int
var level: int = 0


signal go_to_work_pressed
signal go_to_sacrifice_pressed
signal go_to_sacrifice_pressed_work
signal at_work
signal go_to_war

#ANIMATIONS
signal play_sacrifice_place_animation
signal click_summon_animation
signal mana_created
signal mana_from_click_gained

var click_count: int = 0
#it will take this amount of clicks to summon a minion
var clicks_to_spawn: int = 5
#number of minions spawned at one time
#can be upgraded
var number_of_minions: int = 1
var number_of_spawns_cost: int = 100

@export var minions_at_work: int = 0
@export var minions_sacrificed: int = 0
@export var minions_summoned: int = 0
@export var minions_ready_for_war: int = 0

@export var mana: int = 0
var mana_click_count: int = 0
#can be upgraded
var clicks_to_get_mana: int = 10

#can be upgraded
var mana_per_click: int = 1
var mana_per_work_hour: int = 1

#can be upgraded
var someone_at_work: bool = false
var max_at_work: int = 10
@export var work_timer: float
#can be upgraded
var work_timer_base: float = 10.0
var work_upgrade_cost: int = 25
var work_place_level: int = 0

##GAME TIMER
var game_is_running: bool = false #I will need to stop time in order to do the fighting
var game_is_about_to_end: bool = false #this will tell me if I am close to timers end
var game_timer: float 
var base_game_time: float = 60.0 #change this to higher number, like 60 or something
var minutes: int = 0
var seconds: int = 0
var msec: int = 0


#1 = spawn
#2 = work
#3 = sacrifice
#4 = war
var mouse_position_name: String

func _ready():
	$bg_sound.play()
	game_timer = base_game_time
	game_is_running = false
	work_timer = work_timer_base
	%UpdateWorkLabel.text = "cost: " + str(work_upgrade_cost)
	%UpdateSpawnLabel.text = "cost: " + str(number_of_spawns_cost)

func _physics_process(delta):
	
	%WorkCapacityUI.text = "capacity: " + str(max_at_work)
	
	if game_is_running:
		$bg_sound.play()
		game_timer -= delta
		%Second.text = "%3d" % game_timer
		msec = fmod(game_timer, 1) * 100
		seconds = fmod(game_timer, 60)
		minutes = fmod(game_timer, 3600) / 60
		#%Minutes.text = "%02d:" % minutes
		#%Second.text = "%02." % seconds
		#%Msecs.text = "%3d" % msec
		if game_timer <= 0:
			game_is_running = false
			game_is_about_to_end = false
			timer_timeout()
	
	
	
	if minions_at_work > 0:
		someone_at_work = true
	else:
		someone_at_work = false
	
	if someone_at_work:
		work_timer -= delta
		if work_timer <= 0:
			#animation of +1 mana raising from workstation
			emit_signal("mana_created")
			create_mana(mana_per_work_hour)
			set_work_timer_base()

func set_work_timer_base():
	#I am missing checking the variable of how many minions are at work
	if work_place_level == 0:
		set_work_increments(10)
	elif work_place_level == 1:
		set_work_increments(9)
	elif work_place_level == 2:
		set_work_increments(8)
	elif work_place_level == 3:
		set_work_increments(7)
	elif work_place_level == 4:
		set_work_increments(6)
	elif work_place_level == 5:
		set_work_increments(5)
	elif work_place_level > 5:
		set_work_increments(5)

func set_work_increments(increment: int):
		work_timer_base = increment
		work_timer = work_timer_base

func create_mana(amount_of_mana: int):
	mana += amount_of_mana
	update_mana_count_ui()

func buy_mana():
	if minions_sacrificed >= 5:
		mana += 1
		minions_sacrificed -= 5
		update_sacrifice_count_ui()
		update_mana_count_ui()
	else:
		#make a visual error on screen
		print("not enough sacrifices")

func update_sacrifice_count_ui():
	%SacrificedMinions.text = "Sacrificed: " + str(minions_sacrificed)


func update_mana_count_ui():
	%Mana.text = "Mana: " + str(mana)

func update_mouse_position(selected_position: int):
	match selected_position:
		1: 
			mouse_position_name = "Spawn"
			%SpawnUIposition.visible = true
			%SacrificeAreaUI.visible = false
			%WorkUIposition.visible = false
		2:
			mouse_position_name = "Work"
			%SpawnUIposition.visible = false
			%SacrificeAreaUI.visible = false
			%WorkUIposition.visible = true
		3:
			mouse_position_name = "Sacrifice"
			%SpawnUIposition.visible = false
			%WorkUIposition.visible = false
			%SacrificeAreaUI.visible = true
		4:
			mouse_position_name = "War"
			%SpawnUIposition.visible = false
			%WorkUIposition.visible = false
			%SacrificeAreaUI.visible = false


#basic minion summon
func summon_basic_minion(count: int):
	#prepare to summon more minions at one time
	if mouse_position_name == "Spawn":# && game_is_running:
		for i in range(count):
			var new_minion = preload("res://Scenes/basic_minion.tscn").instantiate()
			%SpawnPath2D.progress_ratio = randf()
			new_minion.global_position = %SpawnPath2D.global_position
			add_child(new_minion)
			minions_summoned += 1
			%Summoned.text = "Summoned :" + str(minions_summoned)
	if mouse_position_name == "Work":# && game_is_running:
		for i in range(minions_at_work):
			var new_minion = preload("res://Scenes/basic_minion.tscn").instantiate()
			%SpawnAtWork.progress_ratio = randf()
			new_minion.global_position = %SpawnAtWork.global_position
			add_child(new_minion)
			minions_at_work -= count
	if game_is_running == false:
		for i in range(minions_ready_for_war):
			var new_minion = preload("res://Scenes/basic_minion.tscn").instantiate()
			%WarFollowPath.progress_ratio = randf()
			new_minion.global_position = %WarFollowPath.global_position
			add_child(new_minion)

#clicking on the summoning area creates basic amount of mana
func _on_spawning_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		#click animation
		emit_signal("click_summon_animation")
		#click sound
		$Click.play()
		update_mouse_position(1)
		click_count += 1
		if click_count >= clicks_to_spawn:
			summon_basic_minion(number_of_minions)
			click_count = 0
		mana_click_count += 1
		if mana_click_count >= clicks_to_get_mana:
			create_mana(mana_per_click)
			emit_signal("mana_from_click_gained")
			mana_click_count = 0

#walk to work from spawn
func _on_go_to_work_pressed():
	#walk to work
	if minions_at_work < max_at_work:
		emit_signal("go_to_work_pressed")
	else:
		print("You have reached the work capacity")

#walk to sacrifice from work
func _on_go_to_sacrifice_from_work_pressed():
	summon_basic_minion(minions_at_work)
	minions_at_work -= minions_at_work
	%MinionsAtWork.text = "At work: " + str(minions_at_work)
	emit_signal("go_to_sacrifice_pressed_work")

#mouse clicks on workspace
func _on_work_place_01_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		update_mouse_position(2)

#what happens when any body enters the work
func _on_work_place_01_body_entered(body):
	$AtWorkSound.play()
	minions_at_work += 1
	%MinionsAtWork.text = "At work: " + str(minions_at_work)
	emit_signal("at_work", body)
	#delete all the bodies 
	body.queue_free()

#go to sacrifice from spawn
func _on_go_to_sacrifice_pressed():
	emit_signal("go_to_sacrifice_pressed")

#if minion enters sacrifice area
func _on_sacrifice_body_entered(body):
	$SacrificeSound.play()
	minions_sacrificed += 1
	update_sacrifice_count_ui()
	emit_signal("play_sacrifice_place_animation")
	#death animation
	#death sound
	body.queue_free()

#mouse click on sacrifice area
#will display UI with available updates
func _on_sacrifice_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		update_mouse_position(3)

#go to war button pressed
func _on_go_to_war_pressed():
	emit_signal("go_to_war")

#minions enters the barracks
func _on_war_area_body_entered(body):
	$ToWar.play()
	minions_ready_for_war += 1
	%Barracks.text = "Barracks: " + str(minions_ready_for_war)
	body.queue_free()

#I will make my own timer and will change the scene most likely
func timer_timeout():
	#firts hide all the other UI
	%SpawnUIposition.visible = false
	%WorkUIposition.visible = false
	%SacrificeAreaUI.visible = false
	%Stats.visible = false
	
	%BattleIsHere.visible = true
	level += 1
	if level > 4:
		randNumber = randi_range(1,4)
		selected_oponent(randNumber)
	else:
		selected_oponent(level)
	%BattleInfo.text = "The time is here, you face the army of " + enemy_name + ". Now show them!"
	%CurrentMana.text = "You have " + str(mana) + " mana and army of " + str(minions_ready_for_war) + " accolytes ready for battle"

#END scene with figth
func _on_fight_pressed():
	#summon_basic_minion(minions_ready_for_war)
	%BattleIsHere.visible = false
	#select oponent
	#evaluate fight with oponent
	#change camera to see how minions go to war
	#display fight result
	$BattleResult.visible = true
	fight_evaluation()
	minions_ready_for_war -= minions_ready_for_war
	%Barracks.text = "Barracks: " + str(minions_ready_for_war)


func selected_oponent(enemy_number: int):
	match enemy_number:
		1:
			enemy_name = "Dark Mage Eunit"
			enemy_minions = 25
			%DutchesOfEdon.visible = false
			%DarkMageEunit.visible = true
		2:
			enemy_name = "The Dutches of Edon"
			enemy_minions = 45
			%DarkMageEunit.visible = false
			%DutchesOfEdon.visible = true
		3:
			enemy_name = "Druid Yrot"
			enemy_minions = 75
		4:
			enemy_name = "Lizzard Wizzard"
			enemy_minions = 150
	#var e_attack: int = 2 #maybe use rock, paper, scissors
	#var e_defence: int = 2

func fight_evaluation():
	if level > 4:
		randNumber = randi_range(1,4)
		selected_oponent(randNumber)
	else:
		selected_oponent(level)
	minions_ready_for_war -= enemy_minions
	if minions_ready_for_war < 0:
		%TryAgain.visible = true
		%FightInfo.text = "Your army was crushed, hope you are happy now..."
	elif minions_ready_for_war > 0:
		%Continue.visible = true
		%FightInfo.text = "You won... good for you"
	elif minions_ready_for_war == 0:
		%Continue.visible = true
		%FightInfo.text = "Draw is basically a lost, but I am in a good mood today"
	


#mouse clicked to war zone
#will display the amount of warriors ready and some nice animations
func _on_war_area_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		update_mouse_position(4)

#UPDATE - buy more mana
func _on_buy_mana_pressed():
	buy_mana()

#UPDATE - work capacity +5
func _on_update_work_pressed():
	#need to add max value and inform player that upgrade is at maximum
	if mana >= work_upgrade_cost:
		max_at_work += 5
		mana -= work_upgrade_cost
		work_upgrade_cost += 10
		work_place_level += 1
		update_mana_count_ui()
		%UpdateWorkLabel.text = "cost: " + str(work_upgrade_cost)

#UPDATE - number of minions spawned
func _on_update_spawn_pressed():
	#need to add max value
	if mana >= number_of_spawns_cost:
		number_of_minions += 1
		mana -= number_of_spawns_cost
		number_of_spawns_cost = (number_of_spawns_cost/2) + number_of_spawns_cost
		print(number_of_spawns_cost)
		update_mana_count_ui()
		%UpdateSpawnLabel.text = "cost: " + str(number_of_spawns_cost)

#If we won and continue button is pressed
func _on_continue_pressed():
	game_timer = base_game_time
	game_is_running = true
	%Continue.visible = false
	%BattleResult.visible = false
	%Stats.visible = true

#if we lost and try again is pressed
func _on_try_again_pressed():
	get_tree().reload_current_scene()
