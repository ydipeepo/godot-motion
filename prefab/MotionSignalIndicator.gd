extends Control

export(Color) var triggered_background := Color.red
export(Color) var triggered_foreground := Color.white
export(Color) var waiting_background := Color.black
export(Color) var waiting_foreground := Color.gray

var monitor_object: Node
var monitor_object_key: String

#-------------------------------------------------------------------------------

func _ready() -> void:
	$Started.color = waiting_background
	$Updated.color = waiting_background
	$Finished.color = waiting_background
	$StartedLabel.modulate = waiting_foreground
	$UpdatedLabel.modulate = waiting_foreground
	$FinishedLabel.modulate = waiting_foreground
	Motion.connect("started", self, "_on_motion_started")
	Motion.connect("updated", self, "_on_motion_updated")
	Motion.connect("finished", self, "_on_motion_finished")

func _is_monitor_target(object: Node, object_key: String) -> bool:
	assert(monitor_object != null)
	assert(monitor_object_key != null)
	return monitor_object == object and monitor_object_key == object_key

func _animate(background: ColorRect, foreground: Label) -> void:
	Motion.with(background, "color").limit_overshooting().from(triggered_background).to(waiting_background)
	Motion.with(foreground, "modulate").limit_overshooting().from(triggered_foreground).to(waiting_foreground)

func _on_motion_started(object: Node, object_key: String) -> void:
	if _is_monitor_target(object, object_key):
		_animate($Started, $StartedLabel)

func _on_motion_updated(object: Node, object_key: String) -> void:
	if _is_monitor_target(object, object_key):
		_animate($Updated, $UpdatedLabel)

func _on_motion_finished(object: Node, object_key: String) -> void:
	if _is_monitor_target(object, object_key):
		_animate($Finished, $FinishedLabel)
