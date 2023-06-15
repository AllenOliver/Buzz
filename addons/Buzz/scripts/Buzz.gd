extends Node

## A library for Haptics and Vibration

class_name Buzz

## Called when 
signal OnVibrationBegin
signal OnVibrationEnd

@onready var _vibrationTimer: Timer = $"Vibration Timer"

@export var VibrationEnabled: bool = true

var IsVibrating: bool = false
var ConnectedJoysticks: Array[int]
var _tweenValue:float = 0.0
			
func _ready():
	_vibrationTimer.one_shot = true
	_vibrationTimer.timeout.connect(OnResetVibrationTimer)
	Input.joy_connection_changed.connect(OnJoypadsUpdated)
	if !VibrationEnabled: Disable()
	
	
		

## WIP; Not functional
func TryVibrateFromCurve(_Device: int, CurveLow: Curve, CurveHigh: Curve, _Duration: float)-> bool:
	if IsDeviceConnected(_Device):
		if CanVibrate():
			_tweenValue = 0.0
			IsVibrating = true
			OnVibrationBegin.emit()
			if _Duration > 0: ## We don't want to emit events or worry about the timer if it is a continuous vibration
				_vibrationTimer.start(_Duration)
			
			var _tween: Tween = get_tree().create_tween()
			_tween.tween_property(self,"_tweenValue", 1.0,1.0)	
			_tween.finished.connect(func(): _tweenValue = 0.0)
			Input.start_joy_vibration(_Device, CurveLow.sample(_tweenValue), CurveHigh.sample(_tweenValue), _Duration)
			print(CurveLow.sample(_tweenValue))
			
			return true
	return false

## A raw vibration
func TryVibrateCustom(Device: int, LowMotorStrength: float, HighMotorStrength: float, Duration: float)-> bool:
	if IsDeviceConnected(Device):
		if CanVibrate():
			IsVibrating = true
			OnVibrationBegin.emit()
			Input.start_joy_vibration(Device, clamp(LowMotorStrength, 0, 1), clamp(HighMotorStrength, 0, 1), Duration)
			## We don't want to emit events or worry about the timer if it is a continuous vibration
			if Duration > 0: _vibrationTimer.start(Duration)
			return true
	return false

func TryVibrationPreset(Device: int, Preset: VibrationPreset)-> bool:
	if IsDeviceConnected(Device):
		if CanVibrate():
			IsVibrating = true
			OnVibrationBegin.emit()
			Input.start_joy_vibration(Device, clamp(Preset.LowMotorSpeed, 0, 1), clamp(Preset.HighMotorSpeed, 0, 1), Preset.VibrationDuration)
			## We don't want to emit events or worry about the timer if it is a continuous vibration
			if Preset.VibrationDuration > 0: _vibrationTimer.start(Preset.VibrationDuration)
			return true
	return false

## Stops the specified device from vibrating
func StopVibration(Device: int)-> void:
	if IsVibrating:
		IsVibrating = false
		_vibrationTimer.stop()
		Input.stop_joy_vibration(Device)
		OnVibrationEnd.emit()

## Callback for [signal Timer.timeout]
func OnResetVibrationTimer()-> void:
	OnVibrationEnd.emit()
	IsVibrating = false

## Returns if the specified Device ID is connected to the system	
func IsDeviceConnected(DeviceID: int)-> bool: return ConnectedJoysticks.find(DeviceID)

## Callback for [signal Input.joy_connection_changed]. Updates [ConnectedJoysticks]
func OnJoypadsUpdated(Device: int, Connected: bool): ConnectedJoysticks = Input.get_connected_joypads()

## Creates a new [VibrationPreset] data object.
func CreateNewPreset(PresetName: String, LowMotorSpeed: int, HighMotorSpeed: int, Duration: float)-> VibrationPreset:
	var _newPreset = VibrationPreset.new()
	_newPreset.PresetName = PresetName
	_newPreset.LowMotorSpeed = LowMotorSpeed
	_newPreset.HighMotorSpeed = HighMotorSpeed
	_newPreset.VibrationDuration = Duration
	
	return _newPreset
	
## Tries to save a [VibrationPreset] preset data object to the file system.
func TrySaveNewPreset(Path: String, NewPreset: VibrationPreset)-> bool:
	if ResourceSaver.save(NewPreset, Path) == OK:
		return true
	else:
		return false

## Enables [Buzz] 
func Enable()-> void: VibrationEnabled = true 

## Disables [Buzz]
func Disable()-> void: VibrationEnabled = false

## Enables [Buzz]
func IsEnabled()-> bool: return VibrationEnabled  

## Checks if a vibration can be preformed
func CanVibrate()-> bool: return VibrationEnabled and !IsVibrating
