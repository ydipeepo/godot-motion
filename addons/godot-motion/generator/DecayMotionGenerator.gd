class_name DecayMotionGenerator extends MotionGenerator

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func init_prefer_velocity(
	state: MotionState,
	power: float,
	time_constant: float,
	rest_delta: float) -> void:

	var stride := state.get_element_size()
	var rest_delta_sq := rest_delta * rest_delta
	for i in state.get_element_count():
		var offset: int = i * stride
		var delta_sq := 0.0
		for j in stride:
			var k: int = offset + j
			var v0 := state.get_initial_velocity(k)
			var p0 := state.get_initial_position(k)
			var p1 := p0 + v0 * power
			var x0 := p1 - p0
			state.set_final_position(k, p1)
			delta_sq += x0 * x0
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
				var v0 := (p1 - p0) / time_constant
				state.set_position(k, p0)
				state.set_velocity(k, v0)
				state.set_rest(k, false)

static func init_prefer_position(
	state: MotionState,
	time_constant: float,
	rest_delta: float) -> void:

	var stride := state.get_element_size()
	var rest_delta_sq := rest_delta * rest_delta
	for i in state.get_element_count():
		var offset: int = i * stride
		var delta_sq := 0.0
		for j in stride:
			var k: int = offset + j
			var p0 := state.get_initial_position(k)
			var p1 := state.get_final_position(k)
			var x0 := p1 - p0
			delta_sq += x0 * x0
		if delta_sq <= rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				var p1 := state.get_final_position(k)
				state.set_position(k, p1)
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)
		else:
			for j in state.get_element_size():
				var k: int = offset + j
				var p0 := state.get_initial_position(k)
				var p1 := state.get_final_position(k)
				var x0 := p1 - p0
				state.set_position(k, p0)
				state.set_velocity(k, x0 / time_constant)
				state.set_rest(k, false)

func next(
	state: MotionState,
	delta: float) -> MotionGenerator:

	_total += delta

	var all_at_rest := true
	var exp_total := exp(-_total / _time_constant)
	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride
		var delta_sq := 0.0
		var at_rest := true
		for j in stride:
			var k: int = offset + j
			var p0 := state.get_initial_position(k)
			var p1 := state.get_final_position(k)
			var x0 := p1 - p0
			var e := x0 * exp_total
			var p := p1 - e
			var v := e / _time_constant
			var d := p1 - p
			delta_sq += d * d
			state.set_position(k, p)
			state.set_velocity(k, v)
		if delta_sq <= _rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				state.set_position(k, state.get_final_position(k))
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)
		else:
			at_rest = false
		all_at_rest = at_rest and all_at_rest

	return null if all_at_rest else self

#-------------------------------------------------------------------------------

var _total := 0.0
var _time_constant: float
var _rest_delta_sq: float

func _init(
	time_constant: float,
	rest_delta: float) -> void:

	_time_constant = time_constant
	_rest_delta_sq = rest_delta * rest_delta
