extends CanvasLayer

@onready var gm: Node = get_node("/root/GameManager")

var debug_panel: bool = false

func _process(delta):
	
	if Input.is_action_just_pressed("debug_panel"): #Debug panel for testing
		debug_panel = !debug_panel #press H to show/hide debug
		show_hide_debug()
	
	var rounded_money = gm.usable_money
	
	%alive.text = "Alive: " + str(gm.current_minion_count)
	%deaths.text = "Kills: " + str(gm.kills)
	%money.text = "Money: " + "%.2f" % rounded_money
	
	#GameManager.acolytes_spawn_at_one_time = %BonusSpawn.value
	#GameManager.kill_money_multiplicator = %BonusMoney.value
	
	%BonusSpawn_txt.text = "Spawns per click: " + str(gm.acolytes_spawn_at_one_time)
	%BonusMoney_txt.text = "Money per kill: " + str(gm.kill_money_multiplicator)
	
	#the following will be disabled but changes are visible on the UI
	%screen_shake.button_pressed = gm.screen_shake
	%auto_click.button_pressed = gm.auto_click
	%auto_kill.button_pressed = gm.auto_kill_acolytes
	
	%auto_spawn_txt.text = "Spawn spd: " + str(GameManager.click_timer_base) + "s"
	%auto_kill_txt.text = "Kill spd: " + str(GameManager.auto_kill_base_timer) + "s"

func _on_screen_shake_pressed():
	gm.screen_shake = !gm.screen_shake

func _on_auto_click_pressed():
	gm.auto_click = !gm.auto_click

func _on_auto_kill_pressed():
	gm.auto_kill_acolytes = !gm.auto_kill_acolytes


func show_hide_debug():
	var tween: Tween = get_tree().create_tween()
	if debug_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(0,0), .5).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%MarginContainer, "position", Vector2(-250,0), .5)
