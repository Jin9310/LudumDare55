extends Control



func _on_auto_kill_toggled(toggled_on):
	GameManager.auto_kill_acolytes = !GameManager.auto_kill_acolytes


func _on_screen_shake_toggled(toggled_on):
	GameManager.screen_shake = !GameManager.screen_shake
