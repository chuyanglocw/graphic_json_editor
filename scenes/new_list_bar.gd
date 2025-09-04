extends PanelContainer

@onready var values: VBoxContainer = $VBoxContainer/Values

func _on_add_button_up() -> void:
	var new_value_bar = Items.get_bar_instance(Items.NEW_VALUE_BAR)
	if new_value_bar:
		new_value_bar.show_remove = true
		values.add_child(new_value_bar)
