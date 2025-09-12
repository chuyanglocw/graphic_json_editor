extends Node

const NEW_KEY_BAR = "res://scenes/new_key_bar.tscn"
const NEW_RAW_VALUE_BAR = "res://scenes/new_raw_value_bar.tscn"
const NEW_VALUE_BAR = "res://scenes/new_value_bar.tscn"
const NEW_OBJECT_BAR = "res://scenes/new_object_bar.tscn"
const NEW_LIST_BAR = "res://scenes/new_list_bar.tscn"

const COPIED_ITEM_BAR = "res://scenes/copied_item_bar.tscn"

func get_bar_instance(path: String):
	return load(path).instantiate()
