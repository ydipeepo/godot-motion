extends Control

signal value_changed(value)

export(String) var text: String setget _set_text, _get_text
export(float) var min_value: float setget _set_min_value, _get_min_value
export(float) var max_value: float setget _set_max_value, _get_max_value
export(float) var value: float setget _set_value, _get_value

#-------------------------------------------------------------------------------

func _set_text(value: String) -> void:
	$Label1.text = value

func _get_text() -> String:
	return $Label1.text

func _set_min_value(value: float) -> void:
	$HSlider.min_value = value

func _get_min_value() -> float:
	return $HSlider.min_value

func _set_max_value(value: float) -> void:
	$HSlider.max_value = value

func _get_max_value() -> float:
	return $HSlider.max_value

func _set_value(value: float) -> void:
	$HSlider.value = value

func _get_value() -> float:
	return $HSlider.value

func _ready() -> void:
	$Label2.text = "%.1f" % $HSlider.value

func _on_drag_started() -> void:
	Motion.with($Label1, "modulate:a").limit_overshooting().to(0.0)
	Motion.with($Label2, "modulate:a").limit_overshooting().to(1.0)

func _on_drag_ended(value_changed: bool) -> void:
	Motion.with($Label1, "modulate:a").limit_overshooting().to(1.0)
	Motion.with($Label2, "modulate:a").limit_overshooting().to(0.0)

func _on_value_changed(value: float) -> void:
	$Label2.text = "%.1f" % value
	.emit_signal("value_changed", value)

func _on_mouse_entered() -> void:
	Motion.with(self, "modulate:a").limit_overshooting().to(1.0)

func _on_mouse_exited() -> void:
	Motion.with(self, "modulate:a").limit_overshooting().to(0.25)
