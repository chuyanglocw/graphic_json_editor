extends PanelContainer

@onready var values: VBoxContainer = $MarginContainer/VBoxContainer/Values

var is_mouse_entered := false

var bar_type := ConfigManager.BarType.LISTBAR

func _process(delta: float) -> void:
	if is_mouse_entered and (Input.is_action_just_pressed("choose") or Input.is_action_just_pressed("double_click")):
		Manager.clear_chosen_bars()
		Manager.add_to_chosen_bars(self)
	if is_mouse_entered and (Input.is_key_pressed(KEY_CTRL) or ConfigManager.check_mode):
		$Panel.show()
	else:
		$Panel.hide()

func _on_add_button_up() -> void:
	add_value_bar()

#放回创建的 ValueBar 方便设置内容
func add_value_bar() -> Control:
	var new_value_bar = Items.get_bar_instance(Items.NEW_VALUE_BAR)
	if new_value_bar:
		new_value_bar.show_remove = true
		if ConfigManager.get_cfg_bool(ConfigManager.USE_ENTER_ADD_BAR,false):
			new_value_bar.call_to_add_value_bar.connect(self.deal_call_add)
		values.add_child(new_value_bar)
	return new_value_bar

func deal_call_add() -> void:
	var new_value_bar = Items.get_bar_instance(Items.NEW_VALUE_BAR)
	if new_value_bar:
		new_value_bar.show_remove = true
		if ConfigManager.get_cfg_bool(ConfigManager.USE_ENTER_ADD_BAR,false):
			new_value_bar.call_to_add_value_bar.connect(self.deal_call_add)
		new_value_bar.ready_to_focus = true
		values.add_child(new_value_bar)

func get_value() -> String:
	var temp = "["
	var is_first = true
	for i in values.get_children():
		if not is_first:
			temp = "%s,%s" % [temp,i.get_value()]
		else:
			temp = "%s%s" % [temp,i.get_value()]
			is_first = false
	temp = "%s]" % temp
	return temp

func set_value(values : Array) -> void:
	for value in values:
		var value_bar = add_value_bar()
		if value_bar:
			value_bar.set_value(value)


func _on_mouse_entered() -> void:
	is_mouse_entered = true
	

func _on_mouse_exited() -> void:
	is_mouse_entered = false
