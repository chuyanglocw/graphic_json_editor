extends PanelContainer

@onready var keys: VBoxContainer = $MarginContainer/VBoxContainer/Keys

@export var is_mouse_entered := false

var bar_type := ConfigManager.BarType.OBJECTBAR

func _process(delta: float) -> void:
	if is_mouse_entered and (Input.is_action_just_pressed("choose") or Input.is_action_just_pressed("double_click")):
		Manager.clear_chosen_bars()
		Manager.add_to_chosen_bars(self)
	if is_mouse_entered and (Input.is_key_pressed(KEY_CTRL) or ConfigManager.check_mode):
		$Panel.show()
	else:
		$Panel.hide()

func _on_add_button_up() -> void:
	add_key()

func clear_children() -> void:
	for child in keys.get_children():
		child.queue_free()

func add_key() -> Control:
	var key_bar = Items.get_bar_instance(Items.NEW_KEY_BAR)
	if key_bar:
		if ConfigManager.get_cfg_bool(ConfigManager.USE_ENTER_ADD_BAR,true):
			key_bar.call_to_add_value_bar.connect(self.deal_call_add)
		keys.add_child(key_bar)
	return key_bar

func deal_call_add() -> void:
	var key_bar = Items.get_bar_instance(Items.NEW_KEY_BAR)
	if key_bar:
		if ConfigManager.get_cfg_bool(ConfigManager.USE_ENTER_ADD_BAR,true):
			key_bar.call_to_add_value_bar.connect(self.deal_call_add)
		key_bar.ready_to_focus = true
		keys.add_child(key_bar)

func set_value(value: Dictionary) -> void:
	for key in value.keys():
		var key_bar = add_key()
		if key_bar:
			key_bar.set_key(key)
			key_bar.set_value(value[key])
			

func get_value() -> String:
	var temp = "{"
	var is_first = true
	for i in keys.get_children():
		if not is_first:
			temp = "%s,%s" % [temp,i.get_value()]
		else:
			temp = "%s%s" % [temp,i.get_value()]
			is_first = false
	temp = "%s}" % temp
	return temp


func _on_mouse_entered() -> void:
	is_mouse_entered = true

func _on_mouse_exited() -> void:
	is_mouse_entered = false
