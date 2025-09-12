extends PanelContainer

@onready var key: LineEdit = $MarginContainer/HBoxContainer/Key
@onready var value: HBoxContainer = $MarginContainer/HBoxContainer/Value

func set_key(key_name: String) -> void:
	self.key.text = key_name

func set_value(value) -> void:
	self.value.set_value(value)

func _on_remove_button_up() -> void:
	queue_free()

func get_value() -> String:
	return "\"%s\":%s" % [key.text,value.get_value()]
