extends HBoxContainer

@onready var content: MarginContainer = $Content
@onready var remove: Button = $Remove

@export var show_remove := false

func _ready() -> void:
	if show_remove:
		remove.show()

func _on_remove_button_up() -> void:
	queue_free()

func _on_option_button_item_selected(index: int) -> void:
	if content.get_child_count() > 0:
		content.get_child(0).queue_free()
	if index == 0:
		content.add_child(Items.get_bar_instance(Items.NEW_RAW_VALUE_BAR))
	elif index == 1:
		content.add_child(Items.get_bar_instance(Items.NEW_OBJECT_BAR))
	elif index == 2:
		content.add_child(Items.get_bar_instance(Items.NEW_LIST_BAR))
