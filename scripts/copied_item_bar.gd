extends PanelContainer

@export var copied_file_path: String

@onready var file_type: Label = $MarginContainer/HBoxContainer/PanelContainer/Type
@onready var file_name: Label = $MarginContainer/HBoxContainer/Name

signal paste_button_chosen(copied_file_path:String)
signal delete_button_chosen(copied_file_path:String)
signal copy_button_chosen(copied_file_path:String)

func _ready() -> void:
	set_type_and_name_by_path(copied_file_path)

func set_type_and_name_by_path(file_path: String) -> void:
	file_path = file_path.get_file().get_basename()
	if file_path.begins_with(ConfigManager.LISTBAR):
		file_type.text = ConfigManager.LISTBAR
		self.file_name.text = file_path.trim_prefix(ConfigManager.LISTBAR).trim_prefix("-")
	elif file_path.begins_with(ConfigManager.OBJECTBAR):
		file_type.text = ConfigManager.OBJECTBAR
		self.file_name.text = file_path.trim_prefix(ConfigManager.OBJECTBAR).trim_prefix("-")


func _on_paste_button_up() -> void:
	paste_button_chosen.emit(copied_file_path)

func _on_delete_button_up() -> void:
	delete_button_chosen.emit(copied_file_path)
	self.queue_free()

func _on_copy_button_up() -> void:
	copy_button_chosen.emit(copied_file_path)
