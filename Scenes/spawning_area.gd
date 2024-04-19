extends Area2D

signal spawn_basic_minion

@onready var animPlayer = $AnimationPlayer
#@onready var game: Node = get_node("/root/Game")

@export var number_of_all_clicks: int = 0
var number_of_clicks: int
var clicks_to_spawn: int = 2

func _ready():
	#game.connect("click_summon_animation", click_anim)
	number_of_clicks = clicks_to_spawn


func click_anim():
	animPlayer.play("click")


func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		%CameraAnim.play("shake") #camera shake
		click_anim() #play click animation
		#play click sound
		number_of_all_clicks += 1 # count all the clicks done
		number_of_clicks -= 1
		if number_of_clicks <= 0: #spawn a minion
			emit_signal("spawn_basic_minion")
			number_of_clicks = clicks_to_spawn
