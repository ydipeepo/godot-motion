tool extends EditorPlugin

#-------------------------------------------------------------------------------

func _enter_tree() -> void:
	.add_autoload_singleton("Motion", "res://addons/godot-motion/Motion.gd")

func _exit_tree() -> void:
	.remove_autoload_singleton("Motion")
