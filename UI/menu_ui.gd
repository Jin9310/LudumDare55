extends Control

func _process(delta):
	%minion_count.text = str(GameManager.current_minion_count)

func _on_auto_kill_toggled(toggled_on):
	GameManager.auto_kill_acolytes = !GameManager.auto_kill_acolytes


func _on_screen_shake_toggled(toggled_on):
	GameManager.screen_shake = !GameManager.screen_shake


func _on_auto_kill_2_toggled(toggled_on):
	GameManager.auto_click = !GameManager.auto_click
