extends Control

signal toggled(checked)

export(String) var text: String setget _set_text, _get_text
export(String) var checked_text := "Checked"
export(String) var unchecked_text := "Unchecked"
export(bool) var checked: bool setget _set_checked, _get_checked

#-------------------------------------------------------------------------------

func _set_text(value: String) -> void:
	$Label1.text = value

func _get_text() -> String:
	return $Label1.text

func _set_checked(value: bool) -> void:
	$CheckBox.pressed = value

func _get_checked() -> bool:
	return $CheckBox.pressed

func _on_toggled(button_pressed: bool) -> void:
	$Label2.text = checked_text if $CheckBox.pressed else unchecked_text
	Motion.with($Label2, "modulate:a").set_stiffness(10.0).set_mass(5.0).limit_overshooting().by(2.5).to(0.0)
	.emit_signal("toggled", button_pressed)

func _on_mouse_entered() -> void:
	Motion.with(self, "modulate:a").limit_overshooting().to(1.0)

func _on_mouse_exited() -> void:
	Motion.with(self, "modulate:a").limit_overshooting().to(0.25)
