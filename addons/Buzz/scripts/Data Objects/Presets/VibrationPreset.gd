extends Resource

## A [Resource] for saving vibration preset data for reuse.

class_name VibrationPreset

@export var PresetName: String = "New Vibration Preset"
@export var LowMotorSpeed: int
@export var HighMotorSpeed: int
@export_range(0, 2, .1) var VibrationDuration: float = .1


