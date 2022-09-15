class_name TweenMotionGenerator extends MotionGenerator

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func init(state: MotionState) -> void:
	for k in state.get_element_count() * state.get_element_size():
		state.set_position(k, state.get_initial_position(k))
		state.set_velocity(k, state.get_initial_velocity(k))
		state.set_rest(k, false)

func next(
	state: MotionState,
	delta: float) -> MotionGenerator:

	_total += delta

	if _total < _duration:
		var x := _total / _duration
		var x_D: float
		var x_A: float
		var d: float

		match _ease_type:
			Tween.EASE_IN:
				x_D = 0.0
				x_A = 1.0
			Tween.EASE_OUT:
				x = 1.0 - x
				x_D = 1.0
				x_A = -1.0
			Tween.EASE_IN_OUT:
				if x < 0.5:
					x = x * 2.0
					x_D = 0.0
					x_A = 0.5
				else:
					x = 2.0 - x * 2.0
					x_D = 1.0
					x_A = -0.5
			Tween.EASE_OUT_IN:
				if x < 0.5:
					x = 1.0 - x * 2.0
					x_D = 0.5
					x_A = -0.5
				else:
					x = x * 2.0 - 1.0
					x_D = 0.5
					x_A = 0.5

		match _trans_type:
			Tween.TRANS_LINEAR:
				d = _linear_d(x)
				x = _linear_f(x)
			Tween.TRANS_QUAD:
				d = _quadratic_d(x)
				x = _quadratic_f(x)
			Tween.TRANS_CUBIC:
				d = _cubic_d(x)
				x = _cubic_f(x)
			Tween.TRANS_QUART:
				d = _quartic_d(x)
				x = _quartic_f(x)
			Tween.TRANS_QUINT:
				d = _quintic_d(x)
				x = _quintic_f(x)
			Tween.TRANS_SINE:
				d = _sinusoidal_d(x)
				x = _sinusoidal_f(x)
			Tween.TRANS_EXPO:
				d = _exponential_d(x)
				x = _exponential_f(x)
			Tween.TRANS_CIRC:
				d = _circular_d(x)
				x = _circular_f(x)
			Tween.TRANS_ELASTIC:
				d = _elastic_d(x)
				x = _elastic_f(x)
			Tween.TRANS_BACK:
				d = _back_d(x)
				x = _back_f(x)
			Tween.TRANS_BOUNCE:
				d = _bounce_d(x)
				x = _bounce_f(x)

		var p := x * x_A + x_D
		var v := d

		for k in state.get_element_count() * state.get_element_size():
			var p0 := state.get_initial_position(k)
			var p1 := state.get_final_position(k)
			var x0 := p1 - p0
			state.set_position(k, p0 + x0 * p)
			state.set_velocity(k, v * x0 / _duration)

		return self

	for k in state.get_element_count() * state.get_element_size():
		var p1 := state.get_final_position(k)
		state.set_position(k, p1)
		state.set_velocity(k, 0.0)
		state.set_rest(k, true)

	return null

#-------------------------------------------------------------------------------

var _total := 0.0
var _duration: float
var _ease_type: int
var _trans_type: int

func _init(
	duration: float,
	ease_type: int,
	trans_type: int) -> void:

	assert(0.0 <= duration)

	_duration = duration
	_ease_type = ease_type
	_trans_type = trans_type

#
# 以下 _*_f() はここから頂戴しました:
#
# //github.com/tweenjs/tween.js
#

const _HALF_PI := PI * 0.5
const _5PI := PI * 5.0
const _L1024 := log(1024.0)
const _L2 := log(2.0)
const _S := 1.70158
const _S_1 := _S + 1.0

static func _linear_f(x: float) -> float:
	return x

static func _linear_d(x: float) -> float:
	return 1.0

static func _quadratic_f(x: float) -> float:
	return x * x

static func _quadratic_d(x: float) -> float:
	return 2.0 * x

static func _cubic_f(x: float) -> float:
	return x * x * x

static func _cubic_d(x: float) -> float:
	return 3.0 * x * x

static func _quartic_f(x: float) -> float:
	return x * x * x * x

static func _quartic_d(x: float) -> float:
	return 4.0 * x * x * x

static func _quintic_f(x: float) -> float:
	return x * x * x * x * x

static func _quintic_d(x: float) -> float:
	return 5.0 * x * x * x * x

static func _sinusoidal_f(x: float) -> float:
	return 1.0 - sin((1.0 - x) * _HALF_PI)

static func _sinusoidal_d(x: float) -> float:
	return PI * cos((1.0 - x) * _HALF_PI) * 0.5

static func _exponential_f(x: float) -> float:
	return 0.0 if x == 0.0 else pow(1024.0, x - 1.0)

static func _exponential_d(x: float) -> float:
	return _L1024 * pow(1024, x - 1.0)

static func _circular_f(x: float) -> float:
	return 1.0 - sqrt(1.0 - x * x)

static func _circular_d(x: float) -> float:
	return x / sqrt(1.0 - x * x)

static func _elastic_f(x: float) -> float:
	#
	# TODO:
	# 以下と異なるため必要であれば _elastic_d と合わせて直す。
	#
	# //github.com/godotengine/godot/blob/3bd74cd67bfc5484b3f5d4b47da66c55457474c7/scene/animation/easing_equations.h#L205
	# //upshots.org/
	#

	if x == 0.0:
		return 0.0
	if x == 1.0:
		return 1.0
	return -pow(2.0, 10.0 * (x - 1.0)) * sin((x - 1.1) * _5PI)

static func _elastic_d(x: float) -> float:
	var t := _5PI * (x - 1.1)
	return -(10.0 * _L2 * sin(t) + _5PI * cos(t)) * pow(2.0, 10.0 * x - 10.0)

static func _back_f(x: float) -> float:
	#
	# TODO:
	# EASE_IN_OUT, EASE_OUT_IN において
	# 以下と異なるため必要であれば _back_d と合わせて直す。
	#
	# //github.com/godotengine/godot/blob/3bd74cd67bfc5484b3f5d4b47da66c55457474c7/scene/animation/easing_equations.h#L371
	# //upshots.org/
	#

	return 1.0 if x == 1.0 else x * x * (_S_1 * x - _S)

static func _back_d(x: float) -> float:
	return x * x * _S_1 + 2.0 * x * (_S_1 * x - _S)

static func _bounce_f(x: float) -> float:
	return 1.0 - _bounce_f_forward(1.0 - x)

static func _bounce_d(x: float) -> float:
	return _bounce_d_forward(1.0 - x)

static func _bounce_f_forward(x: float) -> float:
	if x < 1.0 / 2.75:
		return 7.5625 * x * x
	if x < 2.0 / 2.75:
		x -= 1.5 / 2.75
		return 7.5625 * x * x + 0.75
	if x < 2.5 / 2.75:
		x -= 2.25 / 2.75
		return 7.5625 * x * x + 0.9375
	x -= 2.625 / 2.75
	return 7.5625 * x * x + 0.984375

static func _bounce_d_forward(x: float) -> float:
	if x < 1.0 / 2.75:
		return 15.125 * x
	if x < 2.0 / 2.75:
		return 15.125 * x - 8.25
	if x < 2.5 / 2.75:
		return 15.125 * x - 12.375
	return 15.125 * x - 14.4375
