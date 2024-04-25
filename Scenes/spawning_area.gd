extends Area2D

signal spawn_basic_minion

@onready var animPlayer = $AnimationPlayer

@export var number_of_all_clicks: int = 0
var number_of_clicks: int
var clicks_to_spawn: int = 1 #can be upgraded

#automatic clicking 
var click_timer: float

var auto_anim_start_ended: bool = false

func _ready():
	
	number_of_clicks = clicks_to_spawn
	click_timer = GameManager.click_timer_base

func _physics_process(delta):
	#auto clicking
	if GameManager.auto_click && GameManager.current_minion_count < 100:
		click_timer -= delta
		if click_timer <= 0:
			if GameManager.screen_shake: #do a screenshake even after automatick click
				cam_shake()
			emit_signal("spawn_basic_minion")
			if GameManager.auto_click != true:
				click_anim()
			elif GameManager.auto_click == true && auto_anim_start_ended == true:
				auto_click_anim()
			#earn money
			GameManager.usable_money += 1 * GameManager.click_money_multiplicator
			#base timer can be updated so the auto clicks are faster
			click_timer = GameManager.click_timer_base
	
	if GameManager.auto_click == true:
		if auto_anim_start_ended == false:
			animPlayer.play("auto_click_start")
		

func click_anim():
	animPlayer.play("click")

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouse_click"): #manual clicking
		#earn money even if nothing is spawned?
		GameManager.usable_money += 1 * GameManager.click_money_multiplicator
		##
		if GameManager.screen_shake: #screen shake enabler > prepared for UI where I want users to choose if screenshake is allowed or not
			cam_shake() #camera shake
		if GameManager.auto_click != true:
			click_anim() #play click animation
		elif GameManager.auto_click == true && auto_anim_start_ended == true:
			auto_click_anim()
		#play click sound
		number_of_all_clicks += 1 # count all the clicks done
		number_of_clicks -= 1
		if number_of_clicks <= 0 && GameManager.current_minion_count < 100: #spawn a minion and make sure thehe is no more than 100 active acolytes at the moment
			emit_signal("spawn_basic_minion")
			number_of_clicks = clicks_to_spawn

func cam_shake():
	var rand = randi_range(0, 1)
	if rand == 0:
		#print(str(rand))
		%CameraAnim.play("shake")
	else:
		#print(str(rand))
		%CameraAnim.play("shake2")

func shake_ended(): #this is to make sure that camera ends in the correct position after shake
	%CameraAnim.play("idle")

func auto_click_anim():
	animPlayer.play("auto_click")

func animation_ended():
	auto_anim_start_ended= true
	auto_click_anim()


