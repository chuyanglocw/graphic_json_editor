extends Node

@export var chosen_bars: Array[Control] = []

@export var dialog: Control

@export var display_chosen_bar_type_label: Label

func add_to_chosen_bars(bar) -> void:
	chosen_bars.append(bar)
	if display_chosen_bar_type_label:
		if bar.bar_type == ConfigManager.BarType.LISTBAR:
			display_chosen_bar_type_label.set_text("LIST")
		elif bar.bar_type == ConfigManager.BarType.OBJECTBAR:
			display_chosen_bar_type_label.set_text("OBJECT")

func clear_chosen_bars() -> void:
	chosen_bars.clear()

func insert() -> void:
	if dialog:
		#注意只要实现该信号接口就可以作为插入框
		if not dialog.content_returned.is_connected(self.deal_content):
			dialog.content_returned.connect(self.deal_content)
	else:
		print("请设置插入框")

func deal_content(content: String) -> void:
	var json_parsed = JSON.parse_string(content)
	if chosen_bars.size() > 0:
		var chosen_bar = chosen_bars[0]
		if typeof(json_parsed) == TYPE_DICTIONARY and chosen_bar.bar_type == ConfigManager.BarType.OBJECTBAR:
			chosen_bar.set_value(json_parsed)
		elif typeof(json_parsed) == TYPE_ARRAY and chosen_bar.bar_type == ConfigManager.BarType.LISTBAR:
			chosen_bar.set_value(json_parsed)
		else:
			print("选择添加与选中不匹配")

#说明： 用于 Clipboard 功能 type 用于判断是否可以插入对应 Bar 使用
func save_bars_content(display_name: String, sort_group: String, as_value_bar: bool) -> void:
	if chosen_bars.size() <= 0:
		return
	var chosen_bar = chosen_bars[0]
	if chosen_bar.bar_type == ConfigManager.BarType.LISTBAR:
		display_name = "list_bar-" + display_name
	elif chosen_bar.bar_type == ConfigManager.BarType.OBJECTBAR:
		display_name = "object_bar-" + display_name
	
	var slipboard_folder = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_FOLDER)
	var recently_using = slipboard_folder + "/" + ConfigManager.CLIPBOARD_RECENTLY_USING
	var sort_group_folder = slipboard_folder + "/" + sort_group
	var copied_content_file = sort_group_folder + "/" + display_name
	#创建分类
	if not DirAccess.dir_exists_absolute(sort_group_folder):
		DirAccess.make_dir_recursive_absolute(sort_group_folder)
	#判断是否有相同文件了已经
	var file_final_path = copied_content_file + ".json"
	var index = 1
	while FileAccess.file_exists(file_final_path):
		file_final_path = copied_content_file + str(index) + ".json"
		index += 1
	var file = FileAccess.open(file_final_path,FileAccess.WRITE)
	#开始写入
		
	file.store_string(chosen_bar.get_value())
	file.flush()
	file.close()
	print("Copied Chosen Bar to:",file_final_path)
