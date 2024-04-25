extends CanvasLayer

@onready var gm: Node = get_node("/root/GameManager")

var debug_panel: bool = false


##HUD to hold the prices??
## fixed prices ##
var auto_click_price: float = 0 #one time price
var auto_kill_price: float = 0 #one time price
var kill_all_button_price: float = 0
### prices that scale ###
var faster_auto_kill_price: float = 0 
var faster_auto_click_price: float = 0
var kill_money_upgrade: float = 0
var click_money_upgrade: float = 0

func _process(delta):
	
	if Input.is_action_just_pressed("debug_panel"): #Debug panel for testing
		debug_panel = !debug_panel #press H to show/hide debug
		show_hide_debug()
	
	var rounded_money = gm.usable_money
	
	%alive.text = "Alive: " + str(gm.current_minion_count)
	%deaths.text = "Kills: " + str(gm.kills)
	%money.text = "Money: " + "%.2f" % rounded_money
	
	GameManager.acolytes_spawn_at_one_time = %BonusSpawn.value
	GameManager.kill_money_multiplicator = %BonusMoney.value
	
	%BonusSpawn_txt.text = "Spawns per click: " + str(%BonusSpawn.value)
	%BonusMoney_txt.text = "Money per kill: " + str(%BonusMoney.value)


func _on_screen_shake_pressed():
	gm.screen_shake = !gm.screen_shake

func _on_auto_click_pressed():
	if gm.usable_money >= auto_click_price:
		gm.auto_click = !gm.auto_click
		gm.usable_money -= auto_click_price

func _on_auto_kill_pressed():
	if gm.usable_money >= auto_kill_price:
		gm.auto_kill_acolytes = !gm.auto_kill_acolytes
		gm.usable_money -= auto_kill_price

func show_hide_debug():
	var tween: Tween = get_tree().create_tween()
	if debug_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(0,0), .5)
	else:
		tween.tween_property(%MarginContainer, "position", Vector2(-200,0), .5)
