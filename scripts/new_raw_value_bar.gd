extends LineEdit

class_name ContentEdit

signal submit()
var ready_to_focus: bool = false

func _ready() -> void:
	if ready_to_focus:
		grab_focus()

func get_value() -> String:
	if str_to_var(text):
		return text
	else:
		return "\"%s\"" % text

func set_value(value) -> void:
	self.text = str(value)
	print("Loading raw value: ", self.text)

func _on_text_submitted(_new_text: String) -> void:
	submit.emit()
