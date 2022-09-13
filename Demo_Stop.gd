extends Control

var flag := true

func _on_Animate_pressed():
	if flag:
		Motion.with($Icon, "position:x").to(960.0)
	else:
		Motion.with($Icon, "position:x").to(64.0)
	flag = not flag

func _on_Stop_pressed():
	Motion.stop($Icon, "position:x")
