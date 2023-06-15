extends Control

@onready var HighVibration_SpinBox	: SpinBox = $"Control/Controls Panel/High Vibration Container/Panel/HighVibration_SpinBox"
@onready var LowVibration_SpinBox	: SpinBox = $"Control/Controls Panel/Low Vibration Container/Panel/LowVibration_SpinBox"
@onready var Duration_SpinBox		: SpinBox = $"Control/Controls Panel/Duration Container/Panel/Duration_SpinBox"
@onready var DeviceID_SpinBox		: SpinBox = $"Control/Controls Panel/Device ID Container/Panel/DeviceID_SpinBox"

@onready var TestVibration_Button	: Button = $"Control/Controls Panel/TestVibration_Button"
@onready var StopVibration_Button	: Button = $"Control/Controls Panel/StopVibration_Button"
@onready var SavePreset_Button		: Button = $"Control/File Panel/SavePreset_Button"
@onready var OpenPreset_Button		: Button = $"Control/File Panel/OpenPreset_Button"

@onready var PresetName_TextEdit	: TextEdit = $"Control/File Panel/Name Holder/Name_TextEdit"
@onready var Path_TextEdit			: TextEdit = $"Control/File Panel/Path Holder/PathOutput_TextEdit"

@onready var VibrationOutput_Label	: RichTextLabel  = $"Control/Output Panel/Output Console Panel/VibrationOutput_Label"

@onready var Xbox_TextureRect		: TextureRect = $"Control/Output Panel/Xbox_TextureRect"

@onready var Xbox_AnimationPlayer	: AnimationPlayer = $"Control/Output Panel/Xbox_TextureRect/AnimationPlayer"

@onready var OpenPreset_FileDialog	: FileDialog = $"Control/File Panel/OpenPreset_FileDialog"


@export var TestLowCurve: Curve
@export var TestHighCurve: Curve

var _currentVibrationDuration		: float = 0
var _currentTestingDeviceID			: int 	= 0
var _currentHighVibrationRate		: int 	= 0
var _currentLowVibrationRate		: int 	= 0

var _currentSavePath				: String = "res://addons/Buzz/Presets/"

# Called when the node enters the scene tree for the first time.
func _ready():
	buzz.OnVibrationBegin.connect(OnStartVibration)
	buzz.OnVibrationEnd.connect(OnEndVibration)
	
	HighVibration_SpinBox.value_changed.connect(OnHighVibrationChange)
	LowVibration_SpinBox.value_changed.connect(OnLowVibrationChange)
	Duration_SpinBox.value_changed.connect(OnDurationChange)
	DeviceID_SpinBox.value_changed.connect(OnDeviceIDChange)
	OpenPreset_Button.pressed.connect(func(): OpenPreset_FileDialog.popup_centered())
	TestVibration_Button.pressed.connect(OnStartVibrationPressed)
	StopVibration_Button.pressed.connect(OnStopVibrationPressed)
	SavePreset_Button.pressed.connect(OnSavePresetPressed)
	OpenPreset_FileDialog.file_selected.connect(OnSelectPresetFile)
	OpenPreset_FileDialog.current_dir = "res://addons/Buzz/Presets/"	

func OnSelectPresetFile(FilePath: String)-> void:
	if ResourceLoader.exists(FilePath):
		var _preset: VibrationPreset = ResourceLoader.load(FilePath)
		if _preset:
			HighVibration_SpinBox.value = _preset.HighMotorSpeed
			LowVibration_SpinBox.value = _preset.LowMotorSpeed
			Duration_SpinBox.value = _preset.VibrationDuration
			PresetName_TextEdit.text = _preset.PresetName
	
func OnStartVibration()-> void:
	VibrationOutput_Label.text = "[shake]Vibrating...[/shake]"
	Xbox_AnimationPlayer.play("Shake")

func OnEndVibration()-> void:
	VibrationOutput_Label.text = "[wave]Press start...[/wave]"
	Xbox_AnimationPlayer.stop()

func OnHighVibrationChange(Value: float)-> void: _currentHighVibrationRate = round(Value)

func OnLowVibrationChange(Value: float)-> void: _currentLowVibrationRate = round(Value)
	
func OnDurationChange(Value: float)-> void: _currentVibrationDuration = Value
	
func OnDeviceIDChange(Value: float)-> void: _currentTestingDeviceID = round(Value)

func OnStartVibrationPressed()-> void:
	buzz.TryVibrateCustom(_currentTestingDeviceID, _currentLowVibrationRate, _currentHighVibrationRate, _currentVibrationDuration)
	#buzz.TryVibrateFromCurve(_currentTestingDeviceID, TestLowCurve, TestHighCurve, 1.0)
func OnStopVibrationPressed()-> void:
	buzz.StopVibration(_currentTestingDeviceID)

func OnSavePresetPressed()-> void:
	if PresetName_TextEdit.get_line(0):
		buzz.TrySaveNewPreset(
			"res://addons/Buzz/Presets/" + PresetName_TextEdit.get_line(0) + ".tres",
			buzz.CreateNewPreset(PresetName_TextEdit.get_line(0), _currentHighVibrationRate, _currentLowVibrationRate, _currentVibrationDuration)
			)
	else:
		print("No name entered!")
	
