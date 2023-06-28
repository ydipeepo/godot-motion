class_name MovadoStateHelper

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func create(position) -> MovadoState:
	assert(position != null)

	if position is MovadoDelayedPosition:
		position = position.get_value()

	var state: MovadoState
	match typeof(position):
		TYPE_FLOAT:
			state = MovadoFloatState.new()
		TYPE_PACKED_FLOAT32_ARRAY:
			state = MovadoFloat32ArrayState.new(len(position))
		TYPE_PACKED_FLOAT64_ARRAY:
			state = MovadoFloat64ArrayState.new(len(position))
		TYPE_VECTOR2:
			state = MovadoVector2State.new()
		TYPE_VECTOR3:
			state = MovadoVector3State.new()
		TYPE_COLOR:
			state = MovadoColorState.new()
		TYPE_PACKED_VECTOR2_ARRAY:
			state = MovadoVector2ArrayState.new(len(position))
		TYPE_PACKED_VECTOR3_ARRAY:
			state = MovadoVector3ArrayState.new(len(position))
		TYPE_PACKED_COLOR_ARRAY:
			state = MovadoColorArrayState.new(len(position))
		_:
			assert(false, "Unknown type: %d" % typeof(position))
	return state

static func set_rest(state: MovadoState, rest: bool) -> void:
	for k in state.get_element_count() * state.get_element_size():
		state.set_rest(k, rest)

static func get_rest(state: MovadoState) -> bool:
	for k in state.get_element_count() * state.get_element_size():
		if not state.get_rest(k):
			return false
	return true

static func set_initial_position(state: MovadoState, initial_position) -> void:
	assert(state != null)

	if initial_position == null:
		for k in state.get_element_count() * state.get_element_size():
			state.set_initial_position(k, state.get_position(k))
	elif initial_position is MovadoDelayedPosition:
		state.initial_position = initial_position.get_value()
	else:
		state.initial_position = float(initial_position)

static func set_final_position(state: MovadoState, final_position) -> void:
	assert(state != null)

	if final_position == null:
		for k in state.get_element_count() * state.get_element_size():
			state.set_final_position(k, state.get_position(k))
	elif final_position is MovadoDelayedPosition:
		state.final_position = final_position.get_value()
	else:
		state.final_position = float(final_position)

static func set_initial_velocity(state: MovadoState, initial_velocity) -> void:
	assert(state != null)

	if initial_velocity == null:
		for k in state.get_element_count() * state.get_element_size():
			if state.get_rest(k):
				state.set_initial_velocity(k, 0.0)
			else:
				state.set_initial_velocity(k, state.get_velocity(k))

	else:
		match typeof(initial_velocity):
			TYPE_FLOAT:
				assert(state is MovadoFloatState)
				state.set_initial_velocity(0, float(initial_velocity))
			TYPE_VECTOR2:
				assert(state is MovadoVector2State)
				state.set_initial_velocity(0, initial_velocity.x)
				state.set_initial_velocity(1, initial_velocity.y)
			TYPE_VECTOR3:
				assert(state is MovadoVector3State)
				state.set_initial_velocity(0, initial_velocity.x)
				state.set_initial_velocity(1, initial_velocity.y)
				state.set_initial_velocity(2, initial_velocity.z)
			TYPE_COLOR:
				assert(state is MovadoColorState)
				state.set_initial_velocity(0, initial_velocity.r)
				state.set_initial_velocity(1, initial_velocity.g)
				state.set_initial_velocity(2, initial_velocity.b)
				state.set_initial_velocity(3, initial_velocity.a)
			TYPE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_FLOAT64_ARRAY:
				assert(
					state is MovadoFloatState or
					state is MovadoFloat32ArrayState or
					state is MovadoFloat64ArrayState or
					state is MovadoVector2State or
					state is MovadoVector2ArrayState or
					state is MovadoVector3State or
					state is MovadoVector3ArrayState or
					state is MovadoColorState or
					state is MovadoColorArrayState)
				var dimension := state.get_element_count() * state.get_element_size()
				assert(len(initial_velocity) == dimension)
				for k in dimension:
					state.set_initial_velocity(k, initial_velocity[k])
			TYPE_PACKED_VECTOR2_ARRAY:
				assert(state is MovadoVector2ArrayState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 2 + 0, initial_velocity[i].x)
					state.set_initial_velocity(i * 2 + 1, initial_velocity[i].y)
			TYPE_PACKED_VECTOR3_ARRAY:
				assert(state is MovadoVector3ArrayState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 3 + 0, initial_velocity[i].x)
					state.set_initial_velocity(i * 3 + 1, initial_velocity[i].y)
					state.set_initial_velocity(i * 3 + 2, initial_velocity[i].z)
			TYPE_PACKED_COLOR_ARRAY:
				assert(state is MovadoColorArrayState)
				assert(len(initial_velocity) == state.get_element_count())
				for i in state.get_element_count():
					state.set_initial_velocity(i * 4 + 0, initial_velocity[i].r)
					state.set_initial_velocity(i * 4 + 1, initial_velocity[i].g)
					state.set_initial_velocity(i * 4 + 2, initial_velocity[i].b)
					state.set_initial_velocity(i * 4 + 3, initial_velocity[i].a)
			_:
				assert(false)
