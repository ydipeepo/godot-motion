class_name MotionStateHelper

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func create(position) -> MotionState:
	assert(position != null)

	if position is MotionDelayedPosition:
		position = position.get_value()

	var state: MotionState
	match typeof(position):
		TYPE_REAL:
			state = RealMotionState.new()
		TYPE_REAL_ARRAY:
			state = RealArrayMotionState.new(len(position))
		TYPE_VECTOR2:
			state = Vector2MotionState.new()
		TYPE_VECTOR2_ARRAY:
			state = Vector2ArrayMotionState.new(len(position))
		TYPE_VECTOR3:
			state = Vector3MotionState.new()
		TYPE_VECTOR3_ARRAY:
			state = Vector3ArrayMotionState.new(len(position))
		TYPE_COLOR:
			state = ColorMotionState.new()
		TYPE_COLOR_ARRAY:
			state = ColorArrayMotionState.new(len(position))
		_:
			assert(false, "Unknown type: %d" % typeof(position))
	return state

static func set_rest(state: MotionState, rest: bool) -> void:
	for k in state.get_element_count() * state.get_element_size():
		state.set_rest(k, rest)

static func get_rest(state: MotionState) -> bool:
	for k in state.get_element_count() * state.get_element_size():
		if not state.get_rest(k):
			return false
	return true

static func set_initial_position(state: MotionState, initial_position) -> void:
	assert(state != null)

	if initial_position == null:
		for k in state.get_element_count() * state.get_element_size():
			state.set_initial_position(k, state.get_position(k))
	elif initial_position is MotionDelayedPosition:
		state.initial_position = initial_position.get_value()
	else:
		state.initial_position = initial_position

static func set_final_position(state: MotionState, final_position) -> void:
	assert(state != null)

	if final_position == null:
		for k in state.get_element_count() * state.get_element_size():
			state.set_final_position(k, state.get_position(k))
	elif final_position is MotionDelayedPosition:
		state.final_position = final_position.get_value()
	else:
		state.final_position = final_position

static func set_initial_velocity(state: MotionState, initial_velocity) -> void:
	assert(state != null)

	if initial_velocity == null:
		for k in state.get_element_count() * state.get_element_size():
			if state.get_rest(k):
				state.set_initial_velocity(k, 0.0)
			else:
				state.set_initial_velocity(k, state.get_velocity(k))

	else:
		match typeof(initial_velocity):
			TYPE_REAL:
				assert(state is RealMotionState)
				state.set_initial_velocity(0, initial_velocity)
			TYPE_VECTOR2:
				assert(state is Vector2MotionState)
				state.set_initial_velocity(0, initial_velocity.x)
				state.set_initial_velocity(1, initial_velocity.y)
			TYPE_VECTOR3:
				assert(state is Vector3MotionState)
				state.set_initial_velocity(0, initial_velocity.x)
				state.set_initial_velocity(1, initial_velocity.y)
				state.set_initial_velocity(2, initial_velocity.z)
			TYPE_COLOR:
				assert(state is ColorMotionState)
				state.set_initial_velocity(0, initial_velocity.r)
				state.set_initial_velocity(1, initial_velocity.g)
				state.set_initial_velocity(2, initial_velocity.b)
				state.set_initial_velocity(3, initial_velocity.a)
			TYPE_ARRAY, TYPE_REAL_ARRAY:
				assert(
					state is RealMotionState or
					state is RealArrayMotionState or
					state is Vector2MotionState or
					state is Vector2ArrayMotionState or
					state is Vector3MotionState or
					state is Vector3ArrayMotionState or
					state is ColorMotionState or
					state is ColorArrayMotionState)
				var dimension := state.get_element_count() * state.get_element_size()
				assert(len(initial_velocity) == dimension)
				for k in dimension:
					state.set_initial_velocity(k, initial_velocity[k])
			TYPE_VECTOR2_ARRAY:
				assert(state is Vector2ArrayMotionState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 2 + 0, initial_velocity[i].x)
					state.set_initial_velocity(i * 2 + 1, initial_velocity[i].y)
			TYPE_VECTOR3_ARRAY:
				assert(state is Vector3ArrayMotionState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 3 + 0, initial_velocity[i].x)
					state.set_initial_velocity(i * 3 + 1, initial_velocity[i].y)
					state.set_initial_velocity(i * 3 + 2, initial_velocity[i].z)
			TYPE_COLOR_ARRAY:
				assert(state is ColorArrayMotionState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 4 + 0, initial_velocity[i].r)
					state.set_initial_velocity(i * 4 + 1, initial_velocity[i].g)
					state.set_initial_velocity(i * 4 + 2, initial_velocity[i].b)
					state.set_initial_velocity(i * 4 + 3, initial_velocity[i].a)
			_:
				assert(false)
