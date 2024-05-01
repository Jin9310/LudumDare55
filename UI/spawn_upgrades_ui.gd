extends CanvasLayer

signal kill_all_pressed

# 431 open position
# 543 closed position
# 580 hidden position

@export var static_upgrades_panel: bool = false #checking if I clicked the btn that opens the options

var mouse_click_upgrade_enabled: bool = false

func _ready():
	#tooltips
	better_kills_tooltip()
	more_spawn_tooltip()
	only_clicks_tooltip()
	max_amount_of_acols_tooltip()

func _process(delta):
	show_hide_panel()
	hide_others()
	if static_upgrades_panel == false:
		%static_upgrades_btn.text = "<"
	else:
		%static_upgrades_btn.text = ">"
	
	if Input.is_action_just_pressed("rmb") && static_upgrades_panel == true:
		static_upgrades_panel = false
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(%SpawnMargin, "position", Vector2(580,40), 0.5)
	
	##Mouse clicking upgrade
	if Input.is_action_just_pressed("mouse_click") && mouse_click_upgrade_enabled:
		GameManager.usable_money += 1 * GameManager.only_click_money_multiplicator


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
		better_kills_tooltip()

func better_kills_tooltip():
	%better_kills_btn.tooltip_text = "Upgrade money gained per kill \ncost: " + str(UpgradesManager.kill_money_upgrade) + "\ncurrent money gain per kill: " + str(GameManager.kill_money_multiplicator)


func _on_more_spawns_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.spawn_more_minions_upgrade:
		GameManager.acolytes_spawn_at_one_time += 1
		GameManager.usable_money -= UpgradesManager.spawn_more_minions_upgrade
		UpgradesManager.spawn_more_minions_upgrade *= 1.6
		more_spawn_tooltip()

func more_spawn_tooltip():
	%more_spawns_btn.tooltip_text = "Upgrade the amount of minions spawned per click \ncost: " + str(UpgradesManager.spawn_more_minions_upgrade) + "\ncurrently spawns " + str(GameManager.acolytes_spawn_at_one_time) + " per click"


func _on_kill_all_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.kill_all_button_price:
		emit_signal("kill_all_pressed")
		GameManager.usable_money -= UpgradesManager.kill_all_button_price


func _on_clicks_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.click_money_upgrade:
		GameManager.usable_money -= UpgradesManager.click_money_upgrade
		UpgradesManager.click_money_upgrade *= 1.6
		if mouse_click_upgrade_enabled == true:
			GameManager.only_click_money_multiplicator += .1
		mouse_click_upgrade_enabled = true
		only_clicks_tooltip()

func only_clicks_tooltip():
	if mouse_click_upgrade_enabled == false:
		%clicks_btn.tooltip_text = "Coins per every mouse click \ncost: " + str(UpgradesManager.click_money_upgrade) + "\ncurrently gains 0 per mouse click"
	else:
		%clicks_btn.tooltip_text = "Coins per every mouse click \ncost: " + str(UpgradesManager.click_money_upgrade) + "\ncurrently gains " + str(GameManager.only_click_money_multiplicator) + " per mouse click"


func _on_max_amount_acol_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.raise_max_amount_of_spawned:
		GameManager.usable_money -= UpgradesManager.raise_max_amount_of_spawned
		GameManager.max_spawned_acolytes += 50
		UpgradesManager.raise_max_amount_of_spawned *= 1.7
		max_amount_of_acols_tooltip()

func max_amount_of_acols_tooltip():
	%max_amount_acol_btn.tooltip_text = "Maximum number of spawned minions on screen \ncost: " + str(UpgradesManager.raise_max_amount_of_spawned) + "\nThe current amount is visible in the bottom bar"
	
