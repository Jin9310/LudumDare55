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
	
	if Input.is_action_just_pressed("rmb") && static_upgrades_panel == true:
		static_upgrades_panel = false
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(%SpawnMargin, "position", Vector2(580,40), 0.5)


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
	if GameManager.usable_money >= UpgradesManager.kill_money_upgrade:
		GameManager.kill_money_multiplicator += .1
		GameManager.usable_money -= UpgradesManager.kill_money_upgrade
		UpgradesManager.kill_money_upgrade *= 1.6

func better_kills_tooltip():
	%better_kills_btn.tooltip_text = "Upgrade money gained per kill \ncost: " + str(UpgradesManager.kill_money_upgrade) + "\ncurrent money gain per kill: " + str(GameManager.kill_money_multiplicator)


func _on_more_spawns_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.spawn_more_minions_upgrade:
		GameManager.acolytes_spawn_at_one_time += 1
		GameManager.usable_money -= UpgradesManager.spawn_more_minions_upgrade
		UpgradesManager.spawn_more_minions_upgrade *= 1.6

func more_spawn_tooltip():
	%more_spawns_btn.tooltip_text = "Upgrade the amount of minions spawned per click \ncost: " + str(UpgradesManager.spawn_more_minions_upgrade) + "\ncurrently spawns " + str(GameManager.acolytes_spawn_at_one_time) + " per click"


func _on_kill_all_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.kill_all_button_price:
		emit_signal("kill_all_pressed")
		GameManager.usable_money -= UpgradesManager.kill_all_button_price

func kill_all_upgrade_tooltip():
	%kill_all_btn.tooltip_text = "Kills all alive minions \ncost: " + str(UpgradesManager.kill_all_button_price) + "\ncurrently alive: " + str(GameManager.current_minion_count)
