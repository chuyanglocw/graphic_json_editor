extends PanelContainer

@export var copied_file_path: String
@export var is_value_bar: bool = false
@export var to_append_group_name : bool = false

@onready var file_type: Label = $MarginContainer/HBoxContainer/PanelContainer/Type
@onready var file_name: Label = $MarginContainer/HBoxContainer/Name

signal paste_button_chosen(copied_file_path:String, is_value_bar:bool)
signal delete_button_chosen(copied_file_path:String)
signal copy_button_chosen(copied_file_path:String, is_value_bar:bool)

func _ready() -> void:
	set_type_and_name_by_path(copied_file_path)
	if to_append_group_name:
		append_group_info()

func set_type_and_name_by_path(file_path: String) -> void:
	file_path = file_path.get_file().get_basename()
	if file_path.begins_with(ConfigManager.LISTBAR):
		file_type.text = ConfigManager.LISTBAR
		self.file_name.text = file_path.trim_prefix(ConfigManager.LISTBAR).trim_prefix("-")
	elif file_path.begins_with(ConfigManager.OBJECTBAR):
		file_type.text = ConfigManager.OBJECTBAR
		self.file_name.text = file_path.trim_prefix(ConfigManager.OBJECTBAR).trim_prefix("-")
	elif file_path.begins_with(ConfigManager.VALUEBAR):
		is_value_bar = true
		file_type.text = ConfigManager.VALUEBAR
		self.file_name.text = file_path.trim_prefix(ConfigManager.VALUEBAR).trim_prefix("-")

func append_group_info() -> void:
	file_name.text = file_name.text + " [" + copied_file_path.get_base_dir().get_file() + "]"

func _on_paste_button_up() -> void:
	if FileAccess.file_exists(copied_file_path):
		paste_button_chosen.emit(copied_file_path, is_value_bar)
	else:
		_on_delete_button_up()

func _on_delete_button_up() -> void:
	delete_button_chosen.emit(copied_file_path)
	self.queue_free()

func _on_copy_button_up() -> void:
	if FileAccess.file_exists(copied_file_path):
		copy_button_chosen.emit(copied_file_path, is_value_bar)
	else:
		_on_delete_button_up()
