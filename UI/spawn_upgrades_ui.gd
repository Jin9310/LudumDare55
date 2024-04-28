extends CanvasLayer

signal kill_all_pressed

# 431 open position
# 543 closed position
# 580 hidden position

@export var static_upgrades_panel: bool = false #checking if I clicked the btn that opens the options

func _process(delta):
	show_hide_panel()
	hide_others()
	
	#tooltips
	better_kills_tooltip()
	more_spawn_tooltip()
	kill_all_upgrade_tooltip()
	
	if static_upgrades_panel == false:
		%static_upgrades_btn.text = "<"
	else:
		%static_upgrades_btn.text = ">"

func show_hide_panel():
	var tween: Tween = get_tree().create_tween()
	if static_upgrades_panel == true:
		tween.tween_property(%SpawnMargin, "position", Vector2(200,40), 0.5)#.set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%SpawnMargin, "position", Vector2(543,40), 0.5)


func _on_static_upgrades_btn_pressed():
	static_upgrades_panel = !static_upgrades_panel

func hide_others(): #check if other panels are selected or not, if yes, hide this one
	var tween: Tween = get_tree().create_tween()
	if StaticUpgradesUi.static_upgrades_panel == true:
		tween.tween_property(%SpawnMargin, "position", Vector2(580,40), 0.5)
	elif StaticUpgradesUi.static_upgrades_panel == false:
		tween.tween_property(%SpawnMargin, "position", Vector2(543,40), 0.5)



func _on_better_kills_btn_pressed():
	GameManager.kill_money_multiplicator += .1

func better_kills_tooltip():
	%better_kills_btn.tooltip_text = "Upgrade money gained per kill \ncost: " + str(Hud.kill_money_upgrade) + "\ncurrent monay gain per kill: " + str(GameManager.kill_money_multiplicator)


func _on_more_spawns_btn_pressed():
	GameManager.acolytes_spawn_at_one_time += 1

func more_spawn_tooltip():
	%more_spawns_btn.tooltip_text = "Upgrade the amount of minions spawned per click \ncost: " + str(Hud.spawn_more_minions_upgrade) + "\ncurrently spanws " + str(GameManager.acolytes_spawn_at_one_time) + " per click"


func _on_kill_all_btn_pressed():
	emit_signal("kill_all_pressed")

func kill_all_upgrade_tooltip():
	%kill_all_btn.tooltip_text = "Kills all alive minions \ncurrently alive: " + str(GameManager.current_minion_count)
