extends Control

func _ready() -> void:
	$MotionSignalIndicator.monitor_object = $MotionPointVisualizer
	$MotionSignalIndicator.monitor_object_key = "point"

	Motion.connect("started", self, "_on_started")
	Motion.connect("updated", self, "_on_updated")
	Motion.connect("finished", self, "_on_finished")

func _input(event: InputEvent) -> void:
	var position
	var velocity

	var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_motion_event and $Animate.checked:
		position = mouse_motion_event.position - $MotionPointVisualizer.center_offset
	if position == null:
		var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_button_event and mouse_button_event.pressed:
			match mouse_button_event.button_index:
				BUTTON_LEFT:
					if not $Animate.checked:
						position = mouse_button_event.position - $MotionPointVisualizer.center_offset
				BUTTON_RIGHT:
					velocity = mouse_button_event.position - $MotionPointVisualizer.center_offset

	if position != null or velocity != null:
		var builder := Motion \
			.with($MotionPointVisualizer, "point") \
			.set_stiffness($Stiffness.value) \
			.set_damping($Damping.value) \
			.set_mass($Mass.value) \
			.set_rest_delta($RestDelta.value) \
			.set_rest_speed($RestSpeed.value)
		if $LimitOverdamping.checked:
			builder.limit_overdamping()
		if $LimitOvershooting.checked:
			builder.limit_overshooting()
		builder.delay($Delay.value)
		if position != null:
			builder.to(position)
		if velocity != null:
			builder.by(velocity)

func _on_animate_toggled(checked: bool) -> void:
	$Description.text = "Move = Set Destination / Right Click = Set Velocity" if checked else "Left Click = Set Destination / Right Click = Set Velocity"

func _on_started(object: Node, object_key: String) -> void:
	if object == $MotionPointVisualizer:
		var state: MotionState = Motion.context.get_state(MotionContext.PROCESSOR_ATTACH_PROPERTY, $MotionPointVisualizer, "point")
		$MotionPointVisualizer.velocity.x = state.get_velocity(0)
		$MotionPointVisualizer.velocity.y = state.get_velocity(1)

func _on_updated(object: Node, object_key: String) -> void:
	if object == $MotionPointVisualizer:
		var state: MotionState = Motion.context.get_state(MotionContext.PROCESSOR_ATTACH_PROPERTY, $MotionPointVisualizer, "point")
		$MotionPointVisualizer.velocity.x = state.get_velocity(0)
		$MotionPointVisualizer.velocity.y = state.get_velocity(1)

func _on_finished(object: Node, object_key: String) -> void:
	if object == $MotionPointVisualizer:
		var state: MotionState = Motion.context.get_state(MotionContext.PROCESSOR_ATTACH_PROPERTY, $MotionPointVisualizer, "point")
		$MotionPointVisualizer.velocity.x = state.get_velocity(0)
		$MotionPointVisualizer.velocity.y = state.get_velocity(1)
