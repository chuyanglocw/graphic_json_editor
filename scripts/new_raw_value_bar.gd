extends LineEdit

func get_value() -> String:
	return text

func set_value(value) -> void:
	if typeof(value) == TYPE_STRING:
		self.text = "\"%s\"" % value
	else:
		self.text = str(value)
