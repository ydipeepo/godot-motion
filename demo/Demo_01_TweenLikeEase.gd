extends Control

const _DURATION := 1.5

func _ready() -> void:
	$TransType.add_item("Tween.TRANS_LINEAR")
	$TransType.add_item("Tween.TRANS_SINE")
	$TransType.add_item("Tween.TRANS_QUINT")
	$TransType.add_item("Tween.TRANS_QUART")
	$TransType.add_item("Tween.TRANS_QUAD")
	$TransType.add_item("Tween.TRANS_EXPO")
	$TransType.add_item("Tween.TRANS_ELASTIC") #
	$TransType.add_item("Tween.TRANS_CUBIC")
	$TransType.add_item("Tween.TRANS_CIRC")
	$TransType.add_item("Tween.TRANS_BOUNCE")
	$TransType.add_item("Tween.TRANS_BACK") #
	$TransType.select(4)

func _start(trans_type: int, ease_type: int) -> void:
	Motion.ease($Icon1, "position:x").set_trans(trans_type).set_ease(ease_type).set_duration(_DURATION).from(128.0).to(1024.0 - 128.0)
	$Tween.stop_all()
	$Tween.interpolate_property($Icon2, "position:x", 128.0, 1024.0 - 128.0, _DURATION, trans_type, ease_type)
	$Tween.start()

func _on_In_pressed():
	_start($TransType.get_selected_items()[0], Tween.EASE_IN)

func _on_Out_pressed():
	_start($TransType.get_selected_items()[0], Tween.EASE_OUT)

func _on_InOut_pressed():
	_start($TransType.get_selected_items()[0], Tween.EASE_IN_OUT)

func _on_OutIn_pressed():
	_start($TransType.get_selected_items()[0], Tween.EASE_OUT_IN)

func _on_Reset_pressed():
	Motion.with($Icon1, "position:x").to(128.0)
	$Icon2.position.x = 128.0
	$Tween.stop_all()

func _on_Stop_pressed():
	Motion.stop($Icon1, "position:x")
	$Tween.stop_all()
