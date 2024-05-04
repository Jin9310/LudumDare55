extends Area2D

@onready var static_upgrades_ui: Node = get_node("/root/StaticUpgradesUi")
@onready var lower_ui_bar: Node = get_node("/root/LowerBar")


# Called when the node enters the scene tree for the first time.
func _ready():
	lower_ui_bar.connect("play_scull", play_scull)
	static_upgrades_ui.connect("play_scull", play_scull)

func _process(delta):
	if Input.is_action_just_pressed("auto_kill"):
		play_scull()

func play_scull():
	$Sprite2D.visible = true
	$ScullPlayer.play("scull_me")

func erase_me_when_i_am_done():
	#queue_free()
	$Sprite2D.visible = false
