@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("buzz", "res://addons/Buzz/scenes/Autoload/Buzz.tscn")
	add_custom_type("VibrationPreset", "Resource", load("res://addons/Buzz/scripts/Data Objects/VibrationPreset.gd"), load("res://addons/Buzz/icons/sound-waves.png"))
	print("Buzz successfully intialized!")

func _exit_tree():
	remove_autoload_singleton("buzz")
	remove_custom_type("VibrationPreset")
	print("Buzz successfully removed!")
