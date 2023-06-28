@tool
extends EditorPlugin

#-------------------------------------------------------------------------------

func _enter_tree() -> void:
	add_autoload_singleton("Motion", "res://addons/godot-movado/Motion.gd")

func _exit_tree():
	remove_autoload_singleton("Motion")
