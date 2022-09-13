class_name DecayMotionGenerator extends MotionGenerator

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func init_prefer_velocity(
	state: MotionState,
	power: float,
	duration: float,
	rest_delta: float) -> void:

	var rest_delta_sq := rest_delta * rest_delta

	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride

		var delta_sq := 0.0
		for j in stride:
			var k: int = offset + j

			var v0 := state.get_initial_velocity(k)
			var p0 := state.get_initial_position(k)
			var p1 := p0 + v0 * power
			state.set_final_position(k, p1)

			var delta := p1 - p0
			delta_sq += delta * delta

		if delta_sq <= rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				state.set_position(k, state.get_final_position(k))
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)

		else:
			for j in state.get_element_size():
				var k: int = offset + j
				var p0 := state.get_initial_position(k)
				var p1 := state.get_final_position(k)
				var v0 := (p1 - p0) / duration
				state.set_position(k, p0)
				state.set_velocity(k, v0)
				state.set_rest(k, false)

static func init_prefer_position(
	state: MotionState,
	duration: float,
	rest_delta: float) -> void:

	var rest_delta_sq := rest_delta * rest_delta

	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride

		var delta_sq := 0.0
		for j in stride:
			var k: int = offset + j

			var position_0 := state.get_initial_position(k)
			var position_1 := state.get_final_position(k)

			var delta := position_1 - position_0
			delta_sq += delta * delta

		if delta_sq <= rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				var position_1 := state.get_final_position(k)
				state.set_position(k, position_1)
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)

		else:
			for j in state.get_element_size():
				var k: int = offset + j
				var position_0 := state.get_initial_position(k)
				var position_1 := state.get_final_position(k)
				var position := position_0
				var velocity := (position_1 - position_0) / duration
				state.set_position(k, position)
				state.set_velocity(k, velocity)
				state.set_rest(k, false)

func next(
	state: MotionState,
	delta: float) -> MotionGenerator:

	_total += delta

	var all_at_rest := true

	var exp_total := exp(-_total / _duration)

	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride

		var at_rest := true
		var delta_sq := 0.0

		for j in stride:
			var k: int = offset + j

			var p0 := state.get_initial_position(k)
			var p1 := state.get_final_position(k)
			var x0 := p1 - p0
			var e := x0 * exp_total

			var position := p1 - e
			var velocity := e / _duration

			var delta_ := p1 - position
			delta_sq += delta_ * delta_

			state.set_position(k, position)
			state.set_velocity(k, velocity)
			at_rest = false

		if delta_sq <= _rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				state.set_position(k, state.get_final_position(k))
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)

		all_at_rest = at_rest and all_at_rest

	return null if all_at_rest else self

#-------------------------------------------------------------------------------

var _total := 0.0
var _duration: float
var _rest_delta_sq: float

func _init(
	duration: float,
	rest_delta: float) -> void:

	_duration = duration
	_rest_delta_sq = rest_delta * rest_delta
