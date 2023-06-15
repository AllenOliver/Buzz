extends Resource

class_name PresetLibrary

enum PRESETS
{
	LONG_BUZZ,
	SHORT_BUZZ,
	BZZZRT
}

var BZZZRT_Preset: VibrationPreset = preload("res://addons/Buzz/Presets/TEST.tres")
var LONGBUZZ_Preset: VibrationPreset = preload("res://addons/Buzz/Presets/TEST.tres")
var SHORTBUZZ_Preset: VibrationPreset = preload("res://addons/Buzz/Presets/TEST.tres")

func GetPreset(Preset: PRESETS)-> VibrationPreset:
	match(Preset):
		PRESETS.BZZZRT:
			return BZZZRT_Preset
		PRESETS.SHORT_BUZZ:
			return SHORTBUZZ_Preset
		PRESETS.LONG_BUZZ:
			return LONGBUZZ_Preset
		_:
			return null
	
