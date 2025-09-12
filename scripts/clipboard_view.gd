extends Control

@onready var sort_groups: OptionButton = $MarginContainer/HBoxContainer/Clipboard/TabBar/MarginContainer/Options/SortGroups
@onready var group_bars: VBoxContainer = $MarginContainer/HBoxContainer/Clipboard/Contents/GroupBars
@onready var recent_bars: VBoxContainer = $MarginContainer/HBoxContainer/Recently/ScrollContainer/RecentBars

@export var copied_file_chosen: String

var recent_list :Array[String] = []

signal groups_loaded(groups: Array[String])
signal group_deleted()

func _ready() -> void:
	update_content()
	init_recent()
	update_item_bars(0)

func update_content() -> void:
	var clipboard_folder = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_FOLDER)
	if DirAccess.dir_exists_absolute(clipboard_folder):
		DirAccess.make_dir_recursive_absolute(clipboard_folder)
	var dirs = DirAccess.open(clipboard_folder)
	if dirs:
		sort_groups.clear()
		for dir in dirs.get_directories():
			sort_groups.add_item(dir.get_file())
		groups_loaded.emit(dirs.get_directories())

func _on_sort_groups_item_selected(index: int) -> void:
	update_item_bars(index)

func update_item_bars(index: int) -> void:
	var item_name = sort_groups.get_item_text(index)
	var clipboard_folder = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_FOLDER)
	var clipboard_sort_group_folder = clipboard_folder + "/" + item_name
	var dir = DirAccess.open(clipboard_sort_group_folder)
	for child in group_bars.get_children():
		child.queue_free()
	for file in dir.get_files():
		var item_bar = Items.get_bar_instance(Items.COPIED_ITEM_BAR)
		item_bar.copied_file_path = clipboard_sort_group_folder+"/"+file
		item_bar.copy_button_chosen.connect(self.handle_copy_button_chosen)
		item_bar.paste_button_chosen.connect(self.handle_paste_button_chosen)
		item_bar.delete_button_chosen.connect(self.handle_delete_button_chosen)
		group_bars.add_child(item_bar)

func init_recent() -> void:
	var recent_file_path = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_RECENTLY_USING)
	if FileAccess.file_exists(recent_file_path):
		var json_parsed = JSON.parse_string(FileAccess.get_file_as_string(recent_file_path))
		if json_parsed:
			json_parsed = json_parsed as Array[String]
			for bar in json_parsed:
				add_to_recent(bar)

func save_recent() -> void:
	var recent_file_path = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_RECENTLY_USING)
	var file = FileAccess.open(recent_file_path,FileAccess.WRITE)
	file.store_string(JSON.stringify(recent_list))
	file.flush()
	file.close()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		self.save_recent()

func add_to_recent(item_bar_path:String) -> void:
	if item_bar_path in recent_list:
		return
	var item_bar = Items.get_bar_instance(Items.COPIED_ITEM_BAR)
	item_bar.copied_file_path = item_bar_path
	item_bar.copy_button_chosen.connect(self.handle_copy_button_chosen_2)
	item_bar.paste_button_chosen.connect(self.handle_paste_button_chosen_2)
	item_bar.delete_button_chosen.connect(self.delete_from_recent)
	recent_list.append(item_bar_path)
	recent_bars.add_child(item_bar)

func delete_from_recent(item_bar_path:String) -> void:
	recent_list.erase(item_bar_path)

func handle_copy_button_chosen(copied_file_path:String) -> void:
	add_to_recent(copied_file_path)
	copied_file_chosen = copied_file_path

func handle_paste_button_chosen(copied_file_path:String) -> void:
	add_to_recent(copied_file_path)
	Manager.deal_content(FileAccess.get_file_as_string(copied_file_path))

func handle_copy_button_chosen_2(copied_file_path:String) -> void:
	copied_file_chosen = copied_file_path

func handle_paste_button_chosen_2(copied_file_path:String) -> void:
	Manager.deal_content(FileAccess.get_file_as_string(copied_file_path))

func handle_delete_button_chosen(copied_file_path:String) -> void:
	DirAccess.remove_absolute(copied_file_path)
	#update_item_bars(sort_groups.selected)

func _on_close_button_up() -> void:
	self.hide()

func _on_delete_button_up() -> void:
	var clipboard_folder = ConfigManager.get_path_for(ConfigManager.CLIPBOARD_FOLDER)
	var group_folder = clipboard_folder + "/" + sort_groups.get_item_text(sort_groups.selected)
	print(group_folder)
	if DirAccess.remove_absolute(group_folder) == OK:
		print("分类组已被永久删除")
	else:
		OS.move_to_trash(group_folder)
		print("分组已被移入系统回收站")
	update_content()
	group_deleted.emit()
