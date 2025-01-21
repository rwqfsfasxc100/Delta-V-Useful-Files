extends "res://Settings.gd"

# Mod version
const EXAMPLE_VERSION = "1.0.0"


# You may want to change many of the variable names to provide a unique identifier
# Make sure anything read by the ModMain is consistent with this file or they will not work
# These are default config values
# Any value not set in the config file will generate the missing values exactly as these are
var ExampleConfig = {
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
var ExamplePath = "user://Examplesettings.cfg"
var ExampleFile = ConfigFile.new()

func _ready():
	loadExampleFromFile()
	saveExampleToFile()


func saveExampleToFile():
	for section in ExampleConfig:
		for key in ExampleConfig[section]:
			ExampleFile.set_value(section, key, ExampleConfig[section][key])
	ExampleFile.save(ExamplePath)


func loadExampleFromFile():
	var error = ExampleFile.load(ExamplePath)
	if error != OK:
		Debug.l("Example Mod: Error loading settings %s" % error)
		return 
	for section in ExampleConfig:
		for key in ExampleConfig[section]:
			ExampleConfig[section][key] = ExampleFile.get_value(section, key, ExampleConfig[section][key])
	loadExampleKeymapFromConfig()

# Keybind setting handlers
func loadExampleKeymapFromConfig():
	for action_name in ExampleConfig.input:
		InputMap.add_action(action_name)
		for key in ExampleConfig.input[action_name]:
			var event = InputEventKey.new()
			event.scancode = OS.find_scancode_from_string(key)
			InputMap.action_add_event(action_name, event)
	emit_signal("controlSchemeChaged")
