extends CanvasLayer

signal kill_all_pressed

# 431 open position
# 543 closed position
# 580 hidden position

@export var static_upgrades_panel: bool = false #checking if I clicked the btn that opens the options

var mouse_click_upgrade_enabled: bool = false

var green_color: Color = Color(0, 1, 0, 1)
var default_color: Color = Color(1, 1, 1, 1)

func _ready():
	#tooltips
	better_kills_tooltip()
	more_spawn_tooltip()
	only_clicks_tooltip()
	max_amount_of_acols_tooltip()
	faster_spawn_tooltip()
	faster_kills_tooltip()
	

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
	
	##enabling of the upgrades that are depending on static upgrades
	#faster spawn
	if GameManager.auto_click:
		%faster_spawn_btn.disabled = false
	#faster kills
	if GameManager.auto_kill_acolytes:
		%faster_kills_btn.disabled = false
	
		#check that we have reached very low numbers on the auto kill/auto spawn speed
	if GameManager.auto_kill_base_timer <= 0.2:
		UpgradesManager.fast_kill_low = true
	
	if GameManager.click_timer_base <= 0.3:
		UpgradesManager.fast_spawn_low = true
	
	#ui color changes based on availability
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.kill_money_upgrade, %better_kills_btn)
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.spawn_more_minions_upgrade, %more_spawns_btn)
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.click_money_upgrade, %clicks_btn)
	upgrade_available_checker(GameManager.usable_money, UpgradesManager.raise_max_amount_of_spawned, %max_amount_acol_btn)
	if %faster_spawn_btn.disabled != true:
		upgrade_available_checker(GameManager.usable_money, UpgradesManager.faster_auto_spawn_price, %faster_spawn_btn)
	if %faster_kills_btn.disabled != true:
		upgrade_available_checker(GameManager.usable_money, UpgradesManager.faster_auto_kill_price, %faster_kills_btn)
	
	any_up_available()

func any_up_available():
	if %better_kills_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	elif %more_spawns_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	elif %clicks_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	elif %max_amount_acol_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	elif %faster_spawn_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	elif %faster_kills_btn.modulate == green_color:
		%static_upgrades_btn.modulate = green_color
	else:
		%static_upgrades_btn.modulate = default_color
	

func upgrade_available_checker(my_money: float, price: float, btn: Button): #color changer
	if my_money >= price:
		btn.modulate = green_color
	else:
		btn.modulate = default_color

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
	%better_kills_btn.tooltip_text = "Upgrade money gained per kill \ncost: " + "%.2f" % UpgradesManager.kill_money_upgrade + "\ncurrent money gain per kill: " + str(GameManager.kill_money_multiplicator)

func _on_more_spawns_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.spawn_more_minions_upgrade:
		GameManager.acolytes_spawn_at_one_time += 1
		GameManager.usable_money -= UpgradesManager.spawn_more_minions_upgrade
		UpgradesManager.spawn_more_minions_upgrade *= 1.6
		more_spawn_tooltip()

func more_spawn_tooltip():
	%more_spawns_btn.tooltip_text = "Upgrade the amount of minions spawned per click \ncost: " + "%.2f" % UpgradesManager.spawn_more_minions_upgrade + "\ncurrently spawns " + str(GameManager.acolytes_spawn_at_one_time) + " per click"


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
		%clicks_btn.tooltip_text = "Coins per every mouse click \ncost: " + "%.2f" % UpgradesManager.click_money_upgrade + "\ncurrently gains 0 per mouse click"
	else:
		%clicks_btn.tooltip_text = "Coins per every mouse click \ncost: " + "%.2f" % UpgradesManager.click_money_upgrade + "\ncurrently gains " + str(GameManager.only_click_money_multiplicator) + " per mouse click"


func _on_max_amount_acol_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.raise_max_amount_of_spawned:
		GameManager.usable_money -= UpgradesManager.raise_max_amount_of_spawned
		GameManager.max_spawned_acolytes += 50
		UpgradesManager.raise_max_amount_of_spawned *= 1.7
		max_amount_of_acols_tooltip()

func max_amount_of_acols_tooltip():
	%max_amount_acol_btn.tooltip_text = "Maximum number of spawned minions on screen \ncost: " + "%.2f" % UpgradesManager.raise_max_amount_of_spawned + "\nThe current amount is visible in the bottom bar"

func _on_faster_spawn_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.faster_auto_spawn_price && UpgradesManager.fast_spawn_low != true:
		GameManager.usable_money -= UpgradesManager.faster_auto_spawn_price
		UpgradesManager.faster_auto_spawn_price *= 1.8
		GameManager.click_timer_base -= .2
		faster_spawn_tooltip()
	if GameManager.usable_money >= UpgradesManager.faster_auto_spawn_price && UpgradesManager.fast_spawn_low && GameManager.click_timer_base > 0.01:
		GameManager.usable_money -= UpgradesManager.faster_auto_spawn_price
		UpgradesManager.faster_auto_spawn_price *= 1.8
		GameManager.click_timer_base -= UpgradesManager.low_multiplicator
		faster_spawn_tooltip()


func faster_spawn_tooltip():
	if GameManager.click_timer_base < 0.01:
		%faster_spawn_btn.tooltip_text = "Upgrade how fast acolytes are spawn \nMaximum reached" + "\nAcolytes spawned every 0s"
		%faster_spawn_btn.disabled = true
	else:
		%faster_spawn_btn.tooltip_text = "Upgrade how fast acolytes are spawn \ncost: " + "%.2f" % UpgradesManager.faster_auto_spawn_price + "\nAcolytes spawned every " + str(GameManager.click_timer_base) + "s"
	

func _on_faster_kills_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.faster_auto_kill_price && UpgradesManager.fast_kill_low != true:
		GameManager.usable_money -= UpgradesManager.faster_auto_kill_price
		UpgradesManager.faster_auto_kill_price *= 1.7
		GameManager.auto_kill_base_timer -= .6
		faster_kills_tooltip()
	if GameManager.usable_money >= UpgradesManager.faster_auto_kill_price && UpgradesManager.fast_kill_low && GameManager.auto_kill_base_timer > 0.01:
		GameManager.usable_money -= UpgradesManager.faster_auto_kill_price
		UpgradesManager.faster_auto_kill_price *= 1.7
		GameManager.auto_kill_base_timer -= UpgradesManager.low_multiplicator
		faster_kills_tooltip()

func faster_kills_tooltip():
	if GameManager.auto_kill_base_timer < 0.01:
		%faster_kills_btn.tooltip_text = "Upgrade how fast acolytes are auto-killed \nMaximum reached" + "\nAcolytes killed every 0s"
		%faster_kills_btn.disabled = true
	else:
		%faster_kills_btn.tooltip_text = "Upgrade how fast acolytes are auto-killed \ncost: " + "%.2f" % UpgradesManager.faster_auto_kill_price + "\nAcolytes killed every " + str(GameManager.auto_kill_base_timer) + "s"
	
