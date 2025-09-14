extends Control

@onready var object_bar: PanelContainer = $VBoxContainer/WorkSpace/MarginContainer/ScrollContainer/ObjectBar
@onready var clipboard_view: Control = $ClipboardView
@onready var copy_bar_save_as_file_dialog: PanelContainer = $CopyBarSaveAsFileDialog

func _ready() -> void:
	Manager.dialog = $InsertJSONDialog
	if ConfigManager.get_cfg_bool(ConfigManager.FIRST_START,true):
		$HelpWindow.show()
	Manager.display_chosen_bar_type_label = $VBoxContainer/Panel/HBoxContainer/Panel

func _process(delta: float) -> void:
	if Input.is_action_just_released("openinsertdialog"):
		_on_insert_button_up()
	if Input.is_action_just_released("opensavedialog"):
		copy()
	if Input.is_action_just_released("openclipboard"):
		_on_clipboard_button_up()
	if Input.is_action_just_released("ui_paste") and not Manager.dialog.visible:
		if clipboard_view.copied_file_chosen and FileAccess.file_exists(clipboard_view.copied_file_chosen):
			Manager.deal_clipboard_bar_content(FileAccess.get_file_as_string(clipboard_view.copied_file_chosen),clipboard_view.copied_is_value_bar)
	if Input.is_action_just_released("save"):
		_on_save_button_up()
	if Input.is_action_just_released("open"):
		_on_open_button_up()

func _on_save_button_up() -> void:
	DisplayServer.file_dialog_show(ConfigManager.SAVING,
	OS.get_executable_path().get_base_dir(),$VBoxContainer/Panel/HBoxContainer/File.text,true,DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,["*.json"],
	self.save_deal)


#后面可以写入别的脚本里面
func save_deal(status: bool, selected_paths: PackedStringArray, selected_filter_index: int) -> void:
	if not status:
		return
	var file = FileAccess.open(selected_paths[0],FileAccess.WRITE)
	file.store_string(object_bar.get_value())
	file.flush()
	file.close()
	
func _on_open_button_up() -> void:
	DisplayServer.file_dialog_show(ConfigManager.OPENNING,
	OS.get_executable_path().get_base_dir(),"",true,DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,["*.json"],
	self.open_deal)

func open_deal(status: bool, selected_paths: PackedStringArray, selected_filter_index: int) -> void:
	if not status:
		return
	
	var json_parsed = JSON.parse_string(FileAccess.get_file_as_string(selected_paths[0]))
	if json_parsed:
		object_bar.clear_children()
		$VBoxContainer/Panel/HBoxContainer/File.text = selected_paths[0].get_file()
		object_bar.set_value(json_parsed)

func copy() -> void:
	print("启动复制")
	if copy_bar_save_as_file_dialog.visible:
		copy_bar_save_as_file_dialog.hide()
	else:
		copy_bar_save_as_file_dialog.show()

func _on_close_button_up() -> void:
	clipboard_view.save_recent()
	ConfigManager.cfg[ConfigManager.FIRST_START] = false
	ConfigManager.save_cfg()
	get_tree().quit()

func _on_copy_bar_save_as_file_dialog_group_added() -> void:
	clipboard_view.update_content()

func _on_copy_bar_save_as_file_dialog_clipboard_item_added() -> void:
	clipboard_view.update_item_bars(clipboard_view.sort_groups.selected)

func _on_clipboard_view_groups_loaded(groups: Array[String]) -> void:
	$CopyBarSaveAsFileDialog.load_sort_groups(groups)

func _on_clipboard_button_up() -> void:
	if $ClipboardView.visible:
		$ClipboardView.hide()
	else:
		$ClipboardView.show()

func _on_insert_button_up() -> void:
	if Manager.dialog.visible:
		Manager.dialog.hide()
	else:
		Manager.dialog.show()
		Manager.insert()

func _on_copy_to_clipboard_button_up() -> void:
	copy()

func _on_check_mode_toggled(toggled_on: bool) -> void:
	ConfigManager.check_mode = toggled_on

func _on_help_button_up() -> void:
	$HelpWindow.show()

func _on_quit_help_window_button_up() -> void:
	$HelpWindow.hide()

func _on_clear_screen_button_up() -> void:
	object_bar.clear_children()
