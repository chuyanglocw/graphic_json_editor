extends PanelContainer

signal content_returned(content: String)

@onready var content: TextEdit = $MarginContainer/VBoxContainer/Content

func _on_close_button_up() -> void:
	content.text = ""
	self.hide()

func _on_use_button_up() -> void:
	content_returned.emit(content.text)
	content.text = ""
