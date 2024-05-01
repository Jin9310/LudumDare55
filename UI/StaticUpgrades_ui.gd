extends CanvasLayer

signal play_scull

# 431 open position
# 543 closed position

@export var static_upgrades_panel: bool = false #checking if I clicked the btn that opens the options

func _process(delta):
	show_hide_panel()
	hide_others()
	
	if static_upgrades_panel == false:
		%static_upgrades_btn.text = "<"
	else:
		%static_upgrades_btn.text = ">"
	
	
	if GameManager.auto_click == true:
		%auto_click_btn.tooltip_text = "Already purchased"
	else:
		%auto_click_btn.tooltip_text = "Automatic summoning over time \ncost: " + str(UpgradesManager.auto_click_price)
	
	if GameManager.auto_kill_acolytes == true:
		%auto_kill_btn.tooltip_text = "Already purchased"
	else:
		%auto_kill_btn.tooltip_text = "Kills minions automaticaly over time \ncost: " + str(UpgradesManager.auto_kill_price)
	
	if Input.is_action_just_pressed("rmb") && static_upgrades_panel == true:
		static_upgrades_panel = false
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(%MarginContainer, "position", Vector2(580,0), 0.5)
	
	
	##disable buttons that are not purchaseable yet
	#if GameManager.usable_money >= UpgradesManager.auto_click_price:
	#	%auto_click_btn.disabled = true
	
	#if GameManager.usable_money >= UpgradesManager.auto_kill_price:
	#	%auto_kill_btn.disabled = true




func show_hide_panel():
	var tween: Tween = get_tree().create_tween()
	if static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(200,0), 0.5)#.set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)

func _on_static_upgrades_btn_pressed():
	static_upgrades_panel = !static_upgrades_panel

func hide_others(): #check if other panels are selected or not, if yes, hide this one
	var tween: Tween = get_tree().create_tween()
	if SpawnUpgradesUi.static_upgrades_panel == true:
		tween.tween_property(%MarginContainer, "position", Vector2(580,0), 0.5)
	elif SpawnUpgradesUi.static_upgrades_panel == false:
		tween.tween_property(%MarginContainer, "position", Vector2(543,0), 0.5)

func _on_auto_click_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_click_price:
		GameManager.auto_click = true
		%auto_click_btn.disabled = true
		GameManager.usable_money -= UpgradesManager.auto_click_price

func _on_auto_kill_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_kill_price:
		GameManager.auto_kill_acolytes = true
		%auto_kill_btn.disabled = true
		GameManager.usable_money -= UpgradesManager.auto_kill_price
		emit_signal("play_scull")

func _on_screenshake_btn_pressed():
	GameManager.screen_shake = !GameManager.screen_shake

func _on_a_click_btn_pressed():
	if GameManager.usable_money >= UpgradesManager.auto_click_price:
		GameManager.auto_click = true
		#%a_click_btn.disabled = true
		GameManager.usable_money -= UpgradesManager.auto_click_price
