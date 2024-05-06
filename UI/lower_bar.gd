extends CanvasLayer

signal kill_all_pressed
signal all_kill_clear_list
signal play_scull
signal enable_camera

@onready var static_upgrades: Node = get_node("/root/StaticUpgradesUi")

var mouse_count: int = 0
var kill_all_active: bool = false

#autofill
var auto_fill_on: bool = false
var auto_fill_timer: float
var auto_fill_timer_base: float = 3.0 # add 1% every 3s

var max_value_progress_bar: float = 250

func _ready():
	%ProgressBar.max_value = max_value_progress_bar
	auto_fill_timer = auto_fill_timer_base
	static_upgrades.connect("auto_fill_enabled", auto_fill_enabled)

func _process(delta):
	%Usable_mone_lbl.text = "%.2f" % GameManager.usable_money
	%MinionsAlive.text = str(GameManager.current_minion_count) + "/" + str(GameManager.max_spawned_acolytes)
	
	if Input.is_action_just_pressed("mouse_click"):
		mouse_count += 1
		%ProgressBar.value += 1
		if mouse_count >= max_value_progress_bar:
			kill_all_active = true
	
	if %ProgressBar.value >= max_value_progress_bar:
		kill_all_active = true
	
	if kill_all_active == false:
		%Kill_all_btn.visible = false
		%ProgressBar.visible = true
	else:
		%Kill_all_btn.visible = true
		%ProgressBar.visible = false
	
	if auto_fill_on:
		auto_fill_timer -= delta
		if auto_fill_timer <= 0:
			%ProgressBar.value += 2.5
			auto_fill_timer = auto_fill_timer_base 
	
	if Input.is_action_just_pressed("camera"):
		%CheckButton.button_pressed = !%CheckButton.button_pressed

func _on_button_pressed():
	emit_signal("kill_all_pressed")
	emit_signal("all_kill_clear_list")
	emit_signal("play_scull") #play scull animation
	mouse_count = 0
	%ProgressBar.value = 0
	kill_all_active = false

func auto_fill_enabled():
	auto_fill_on = true


func _on_check_button_pressed():
	emit_signal("enable_camera")
