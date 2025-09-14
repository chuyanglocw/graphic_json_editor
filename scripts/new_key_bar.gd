extends PanelContainer

@onready var key: LineEdit = $MarginContainer/HBoxContainer/Key
@onready var value: HBoxContainer = $MarginContainer/HBoxContainer/Value

signal call_to_add_value_bar()
var ready_to_focus: bool = false

func _ready() -> void:
	if ready_to_focus:
		to_focus()

func set_key(key_name: String) -> void:
	self.key.text = key_name

func set_value(value) -> void:
	self.value.set_value(value)

func _on_remove_button_up() -> void:
	queue_free()

func get_value() -> String:
	return "\"%s\":%s" % [key.text,value.get_value()]

func _on_key_text_submitted(new_text: String) -> void:
	value.to_focus()

func to_focus() -> void:
	key.grab_focus()

func _on_value_call_to_add_value_bar() -> void:
	call_to_add_value_bar.emit()
