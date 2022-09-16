extends Control

func _on_WithMethod_pressed():
	Motion.with_method(self, "_on_hsv_changed").to(Vector3(randf(), randf(), randf()))

func _on_StopMethod_pressed():
	Motion.stop_method(self, "_on_hsv_changed")

func _on_hsv_changed(value: Vector3) -> void:
	$Hue.text = "H = %.5f" % value.x
	$Saturation.text = "S = %.5f" % value.y
	$Value.text = "V = %.5f" % value.z
	$Card.modulate = Color.from_hsv(value.x, value.y, value.z)
