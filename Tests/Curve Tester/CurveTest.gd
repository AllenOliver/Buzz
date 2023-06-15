extends Control

const BaseFolder: String = "res://addons/Buzz/Presets/"

@onready var _FilePick: FileDialog = $FileDialog
@onready var _OpenFilePicker: Button = $OpenFile_Button


var SelectedPreset: VibrationPreset

# Called when the node enters the scene tree for the first time.
func _ready():
	_FilePick.file_selected.connect(OnPresetSelected)
	_FilePick.access = FileDialog.ACCESS_RESOURCES
	_FilePick.current_dir = BaseFolder
	_OpenFilePicker.pressed.connect(func(): _FilePick.popup_centered())
	

func OnPresetSelected(_path: String):
	if _path.contains(BaseFolder):
		var _preset: VibrationPreset = load(_path)
		if _preset:
			SelectedPreset = _preset
			print(SelectedPreset.VibrationDuration)
