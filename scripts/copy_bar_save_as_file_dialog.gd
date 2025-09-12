extends PanelContainer


@onready var group_name: LineEdit = $MarginContainer/VBoxContainer/SortGroup/GroupName
@onready var display_name: LineEdit = $MarginContainer/VBoxContainer/DiaplayName/DisplayName
@onready var as_value_bar_check_box: CheckButton = $MarginContainer/VBoxContainer/AsValueBar/AsValueBarCheckBox
@onready var sort_group_option: OptionButton = $MarginContainer/VBoxContainer/SortGroup/SortGroupOption

@export var temp_group_name: String = ""

signal group_added()
signal clipboard_item_added()

func load_sort_groups(groups: Array[String]) -> void:
	sort_group_option.clear()
	sort_group_option.add_item("NewGroup")
	for group in groups:
		sort_group_option.add_item(group)

func _on_close_button_up() -> void:
	self.hide()

func _on_save_button_up() -> void:
	self.hide()
	if not display_name.text or not group_name.text:
		print("请输入分类组 和 名字")
		return
	Manager.save_bars_content(display_name.text, group_name.text,as_value_bar_check_box.button_pressed)
	if sort_group_option.selected == 0:
		group_added.emit()
	clipboard_item_added.emit()


func _on_sort_group_option_item_selected(index: int) -> void:
	if index == 0:
		group_name.set_text(temp_group_name)
		group_name.editable = true
	else:
		group_name.set_text(sort_group_option.get_item_text(index))
		group_name.editable = false


func _on_group_name_text_changed(new_text: String) -> void:
	if sort_group_option.selected == 0:
		temp_group_name = new_text

func _on_display_name_text_submitted(new_text: String) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Save.grab_focus()

func _on_group_name_text_submitted(new_text: String) -> void:
	display_name.grab_focus()
