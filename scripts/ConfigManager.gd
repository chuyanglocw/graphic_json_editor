extends Node


#TODO 暂时支持 Windows
const path_format = "%s/%s"

const CONFIG_PATH = "user://config.json"
const CLIPBOARD_FOLDER = "clipboard"
const CLIPBOARD_RECENTLY_USING = CLIPBOARD_FOLDER + "/recently_use.json"

const SAVING = "保存..."
const OPENNING = "打开..."

var check_mode = false
var cfg: Dictionary

const RELATIVE_AS_BASE = "relative_as_base"
const FIRST_START = "first_satrt"

#TODO 添加ValueBar类型及其处理
enum BarType{
	OBJECTBAR,
	LISTBAR,
	VALUEBAR
}
const OBJECTBAR = "object_bar"
const LISTBAR = "list_bar"
const VALUEBAR = "value_bar"

func _ready() -> void:
	load_cfg()

func get_path_for(where: String) -> String:
	if (OS.has_feature("windows") or OS.has_feature("linux")) and get_cfg_bool(RELATIVE_AS_BASE,true):
		return path_format % [OS.get_executable_path().get_basename().get_base_dir(),where]
	else:
		return path_format % ["user://",where]

func get_cfg_num(key: String, default: float) -> float:
	if self.cfg.has(key):
		return cfg[key]
	else:
		cfg[key] = default
		return default

func get_cfg_String(key: String, default: String) -> String:
	if self.cfg.has(key):
		return cfg[key]
	else:
		cfg[key] = default
		return default

func get_cfg_bool(key: String, default: bool) -> bool:
	if self.cfg.has(key):
		return cfg[key]
	else:
		cfg[key] = default
		return default

func get_cfg_object_or_list(key: String, default: Variant) -> Variant:
	if self.cfg.has(key):
		return cfg[key]
	else:
		cfg[key] = default
		return default

func load_cfg() -> void:
	if FileAccess.file_exists(self.CONFIG_PATH):
		self.cfg = JSON.parse_string(FileAccess.get_file_as_string(self.CONFIG_PATH))
	else:
		print("配置文件未创建")

func save_cfg() -> void:
	var cfg_file = FileAccess.open(self.CONFIG_PATH,FileAccess.WRITE)
	cfg_file.store_string(JSON.stringify(cfg))
	cfg_file.flush()
	cfg_file.close()
