extends LineEdit

signal submit()

var ready_to_focus: bool = false

func _ready() -> void:
	if ready_to_focus:
		grab_focus()

func get_value() -> String:
	return text

func set_value(value) -> void:
	if typeof(value) == TYPE_STRING:
		self.text = "\"%s\"" % value
	else:
		self.text = str(value)

func _on_text_submitted(new_text: String) -> void:
	submit.emit()
