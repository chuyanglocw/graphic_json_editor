extends Node


#TODO 暂时支持 Windows
const path_format = "%s/%s"

const CONFIG = "config.json"
const CLIPBOARD_FOLDER = "clipboard"
const CLIPBOARD_RECENTLY_USING = CLIPBOARD_FOLDER + "/recently_use.json"

var check_mode = false

enum BarType{
	OBJECTBAR,
	LISTBAR
}
const OBJECTBAR = "object_bar"
const LISTBAR = "list_bar"

func get_path_for(where: String) -> String:
	return path_format % [OS.get_executable_path().get_basename().get_base_dir(),where]
