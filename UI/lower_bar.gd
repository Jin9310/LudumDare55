extends CanvasLayer

signal kill_all_pressed
signal all_kill_clear_list
signal play_scull

var mouse_count: int = 0
var kill_all_active: bool = false

func _process(delta):
	%Usable_mone_lbl.text = "%.2f" % GameManager.usable_money
	%MinionsAlive.text = str(GameManager.current_minion_count) + "/" + str(GameManager.max_spawned_acolytes)
	
	if Input.is_action_just_pressed("mouse_click"):
		mouse_count += 1
		%ProgressBar.value += 1
		if mouse_count >= 250:
			kill_all_active = true
	
	if kill_all_active == false:
		%Kill_all_btn.visible = false
		%ProgressBar.visible = true
	else:
		%Kill_all_btn.visible = true
		%ProgressBar.visible = false


func _on_button_pressed():
	emit_signal("kill_all_pressed")
	emit_signal("all_kill_clear_list")
	emit_signal("play_scull") #play scull animation
	mouse_count = 0
	%ProgressBar.value = 0
	kill_all_active = false
