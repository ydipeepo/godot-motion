extends Control

func _on_With_pressed():
	Motion.with($Icon, "position").to(rect_size * Vector2(randf(), randf()))

func _on_Stop_pressed():
	Motion.stop($Icon, "position")
