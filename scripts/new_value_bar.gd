extends HBoxContainer

@onready var option: OptionButton = $Option

@onready var content: MarginContainer = $Content
@onready var remove: Button = $Remove

@export var show_remove := false
@export var ready_to_focus := false

signal call_to_add_value_bar()


func _ready() -> void:
	if show_remove:
		remove.show()
	change_content_type(option.selected)

	#TEST String OK
	#set_value("Hello JSONEditor")
	
	#TEST Num OK
	#set_value(18)

	#TEST Bool OK
	#set_value(false)

#DEBUG Function
#func _process(delta: float) -> void:
	#if Input.is_action_just_released("ui_accept"):
		##TEST List OK
		##set_value([[1,2,3],4,5,6])
		#
		##TEST Object OK
		##set_value({"name":"Li Hua","age":18,"family":["Li Da","Zhang Hua"]})
		#pass

func _on_remove_button_up() -> void:
	queue_free()

func _on_option_button_item_selected(index: int) -> void:
	change_content_type(index)

func change_content_type(index: int) -> Control:
	var content_bar = null
	for child in content.get_children():
		child.queue_free()
	if index == 0:
		content_bar = Items.get_bar_instance(Items.NEW_RAW_VALUE_BAR)
		content_bar.submit.connect(self.submit)
		content_bar.ready_to_focus = self.ready_to_focus
		self.ready_to_focus = false
		content.add_child(content_bar)
	elif index == 1:
		content_bar = Items.get_bar_instance(Items.NEW_OBJECT_BAR)
		content.add_child(content_bar)
	elif index == 2:
		content_bar = Items.get_bar_instance(Items.NEW_LIST_BAR)
		content.add_child(content_bar)
	return content_bar

#TODO 写一个根据类型更换 Option 和 状态的 功能 并且 添加 写入 Raw 以及 调用 ObjectBar 、 ListBar 的 SetValue 功能
func set_value(value) -> void:
	var content_bar = null
	if typeof(value) == TYPE_DICTIONARY:
		content_bar = change_content_type(1)
		option.selected = 1
	elif typeof(value) == TYPE_ARRAY:
		content_bar = change_content_type(2)
		option.selected = 2
	else:
		content_bar = change_content_type(0)
		option.selected = 3
	if content_bar:
		content_bar.set_value(value)

func get_value() -> String:
	return content.get_children()[0].get_value() as String

func to_focus() -> void:
	if option.selected == 0:
		content.get_children()[0].grab_focus()

func submit() -> void:
	call_to_add_value_bar.emit()
