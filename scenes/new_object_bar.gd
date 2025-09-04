extends PanelContainer

@onready var keys: VBoxContainer = $VBoxContainer/Keys

func _on_add_button_up() -> void:
	keys.add_child(Items.get_bar_instance(Items.NEW_KEY_BAR))
