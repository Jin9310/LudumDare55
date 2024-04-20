extends Area2D

signal spawn_basic_minion

@onready var animPlayer = $AnimationPlayer

@export var number_of_all_clicks: int = 0
var number_of_clicks: int
var clicks_to_spawn: int = 2 #can be upgraded

#automatic clicking 
var click_timer: float

func _ready():
	number_of_clicks = clicks_to_spawn
	click_timer = GameManager.click_timer_base

func _physics_process(delta):
	if GameManager.auto_click:
		click_timer -= delta
		if click_timer <= 0:
			if GameManager.screen_shake:
				cam_shake()
			emit_signal("spawn_basic_minion")
			click_anim()
			click_timer = GameManager.click_timer_base


func click_anim():
	animPlayer.play("click")

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		if GameManager.screen_shake: #screen shake enabler > prepared for UI where I want users to choose if screenshake is allowed or not
			cam_shake() #camera shake
		click_anim() #play click animation
		#play click sound
		number_of_all_clicks += 1 # count all the clicks done
		number_of_clicks -= 1
		if number_of_clicks <= 0: #spawn a minion
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

