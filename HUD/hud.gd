extends CanvasLayer

@onready var gm: Node = get_node("/root/GameManager")

##HUD to hold the prices??
var auto_click_price: float = 20.0
var auto_kill_price: float = 30.0


func _process(delta):
	%alive.text = "Alive: " + str(gm.current_minion_count)
	%deaths.text = "Kills: " + str(gm.kills)
	%money.text = "Money: " + str(gm.usable_money)

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
