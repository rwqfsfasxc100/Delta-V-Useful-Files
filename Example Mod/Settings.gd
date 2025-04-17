extends "res://Settings.gd"

# You may want to change many of the variable names to provide a unique identifier
# Make sure anything read by the ModMain is consistent with this file or they will not work
# These are default config values
# Any value not set in the config file will generate the missing values exactly as these are
var ExampleMod = {
	"section":{
		"setting":true,
		"string_option":"setting_value"
	}, 
	"section2":{
		"option":false,
		"numerical_option":1000,
	}, 
	"input":{ # Defaults for anything that uses keybinds
		"key_setting_a":[ "R" ],
		"key_setting_b":[ "Shift" ],
	}, 
}

# The config file name. Make sure you set something unique
# Config is set to the cfg folder to make it easy to find
var ConfigPath = "user://cfg/ExampleMod.cfg"
var CfgFile = ConfigFile.new()

func _ready():
	var dir = Directory.new()
	dir.make_dir("user://cfg")
	load_ExampleMod_FromFile()
	save_ExampleMod_ToFile()


func save_ExampleMod_ToFile():
	for section in ExampleMod:
		for key in ExampleMod[section]:
			CfgFile.set_value(section, key, ExampleMod[section][key])
	CfgFile.save(ConfigPath)


func load_ExampleMod_FromFile():
	var error = CfgFile.load(ConfigPath)
	if error != OK:
		Debug.l("Example Mod: Error loading settings %s" % error)
		return 
	for section in ExampleMod:
		for key in ExampleMod[section]:
			ExampleMod[section][key] = CfgFile.get_value(section, key, ExampleMod[section][key])
	loadKeymapsFromConfig()

# Keybind setting handlers
func loadKeymapsFromConfig():
	for action_name in ExampleMod.input:
		var addAction = true
		for m in InputMap.get_actions():
			if m == action_name:
				addAction = false
		if addAction:
			InputMap.add_action(action_name)
		for key in ExampleMod.input[action_name]:
			var event = InputEventKey.new()
			event.scancode = OS.find_scancode_from_string(key)
			InputMap.action_add_event(action_name, event)
	emit_signal("controlSchemeChaged")
