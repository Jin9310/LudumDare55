extends CanvasLayer

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
	
	if GameManager.auto_kill_acolytes == true:
		%auto_click_btn.tooltip_text = "Already purchased"


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
		GameManager.auto_click = true
		%auto_click_btn.disabled = true

func _on_auto_kill_btn_pressed():
	GameManager.auto_kill_acolytes = true
	%auto_kill_btn.disabled = true

func _on_screenshake_btn_pressed():
	GameManager.screen_shake = !GameManager.screen_shake
