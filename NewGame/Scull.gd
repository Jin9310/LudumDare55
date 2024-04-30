extends Area2D

@onready var static_upgrades_ui: Node = get_node("/root/StaticUpgradesUi")

# Called when the node enters the scene tree for the first time.
func _ready():
	static_upgrades_ui.connect("play_scull", play_scull)

func play_scull():
	$ScullPlayer.play("scull_me")

func erase_me_when_i_am_done():
	queue_free()
