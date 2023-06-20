extends Resource

## Holds a set of premade [VibrationPreset]s to use with [Buzz]

class_name PresetLibrary

## An [Enum] that holds presets for vibration.
enum PRESETS
{
	SHORT_BURST,
	BZZZRT,
	LOW_RUMBLE,
	LOUD_BURST
}

var BZZZRT_Preset		: VibrationPreset = preload("res://addons/Buzz/Presets/BZZZZRT.tres")
var LowRumble_Preset	: VibrationPreset = preload("res://addons/Buzz/Presets/LowRumble.tres")
var SHORTBURST_Preset	: VibrationPreset = preload("res://addons/Buzz/Presets/ShortBurst.tres")
var LoudBurst_Preset	: VibrationPreset = preload("res://addons/Buzz/Presets/Loud_Fast.tres")

## Get a [VibrationPreset] from a [enum PRESETS]
func GetPreset(Preset: PRESETS)-> VibrationPreset:
	match(Preset):
		PRESETS.BZZZRT:
			return BZZZRT_Preset
		PRESETS.SHORT_BURST:
			return SHORTBURST_Preset
		PRESETS.LOUD_BURST:
			return LoudBurst_Preset
		PRESETS.LOW_RUMBLE:
			return LowRumble_Preset
		_:
			return null
	
