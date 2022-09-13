class_name SpringMotionGenerator extends MotionGenerator

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

static func init(
	state: MotionState,
	rest_delta: float,
	rest_speed: float) -> void:

	assert(state != null)

	var rest_delta_sq := rest_delta * rest_delta
	var rest_speed_sq := rest_speed * rest_speed

	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride

		var delta_sq := 0.0
		var speed_sq := 0.0
		for j in stride:
			var k: int = offset + j
			var speed := state.get_initial_velocity(k)
			var delta := state.get_final_position(k) - state.get_initial_position(k)
			delta_sq += delta * delta
			speed_sq += speed * speed

		if speed_sq <= rest_speed_sq and delta_sq <= rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				state.set_position(k, state.get_final_position(k))
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)

		else:
			for j in state.get_element_size():
				var k: int = offset + j
				state.set_position(k, state.get_initial_position(k))
				state.set_velocity(k, state.get_initial_velocity(k))
				state.set_rest(k, false)

# ステートを更新しアクティブなジェネレータを返します
func next(
	state: MotionState,
	delta: float) -> MotionGenerator:

	_total += delta

	#while _total >= _TIME_STEP:
	#	for k in state.get_element_count() * state.get_element_size():
	#		if state.get_rest(k):
	#			continue
	#
	#		var position := state.get_position(k)
	#		var velocity := state.get_velocity(k)
	#		var position_1: float = state.get_final_position(k)
	#		if abs(velocity) <= _rest_speed and abs(position_1 - position) <= _rest_delta:
	#			state.set_rest(k, true)
	#			state.set_position(k, position_1)
	#			state.set_velocity(k, 0.0)
	#			continue
	#
	#		var spring_force := -_tension / _TIME_STEP * (position_1 - position)
	#		var damping_force := -_friction / (_TIME_STEP * _TIME_STEP) * velocity
	#		var acceleration := (spring_force + damping_force) / mass
	#		velocity += acceleration * _TIME_STEP
	#		position += velocity * _TIME_STEP
	#
	#		state.set_position(k, position)
	#		state.set_velocity(k, velocity)
	#
	#	_total -= _TIME_STEP

	#
	# Adam Miskiewicz 氏 (@skevy) による wobble での
	# オシレータ実装を真似て解析的な実装に差し替えました (ほぼ同じ):
	#
	# //github.com/skevy/wobble/blob/develop/src/index.ts
	#
	# 過減衰の状態で時間が経過しすぎると双曲線関数が INF を返すので制限を加え、 *2
	# 要素毎に休止判定を行うよう変更してあります *3
	#

	var all_at_rest := true

	var omega_2_total := min(_omega_2 * _total, _MAX_OMEGA_2_TOTAL) # INF を返すので制限しておく *2
	var cos_omega_1_total := cos(_omega_1 * _total)
	var sin_omega_1_total := sin(_omega_1 * _total)
	var cosh_omega_2_total := cosh(omega_2_total)
	var sinh_omega_2_total := sinh(omega_2_total)

	var stride := state.get_element_size()
	for i in state.get_element_count():
		var offset: int = i * stride

		var at_rest := true
		var delta_sq := 0.0
		var speed_sq := 0.0

		for j in stride:
			var k: int = offset + j
			if state.get_rest(k):
				continue

			var p0 := state.get_initial_position(k)
			var p1 := state.get_final_position(k)
			var v0 := -state.get_initial_velocity(k)
			var x0 := p1 - p0

			var position: float
			var velocity: float

			if _zeta < 1.0:
				var u := v0 + _zeta * _omega_0 * x0
				var e := exp(-_zeta * _omega_0 * _total)
				position = p1 - e * ((v0 + _zeta * _omega_0 * x0) / _omega_1 * sin_omega_1_total + x0 * cos_omega_1_total)
				velocity = _zeta * _omega_0 * e * (sin_omega_1_total * u / _omega_1 + x0 * cos_omega_1_total) - e * (cos_omega_1_total * u - _omega_1 * x0 * sin_omega_1_total)

			elif _zeta == 1.0:
				var e := exp(-_omega_0 * _total)
				position = p1 - e * (x0 + (v0 + _omega_0 * x0) * _total)
				velocity = e * (v0 * (_total * _omega_0 - 1.0) + _total * x0 * (_omega_0 * _omega_0))

			else:
				var u := v0 + _zeta * _omega_0 * x0
				var e := exp(-_zeta * _omega_0 * _total)
				position = p1 - e * (u * sinh_omega_2_total + _omega_2 * x0 * cosh_omega_2_total) / _omega_2
				velocity = e * _zeta * _omega_0 * (sinh_omega_2_total * u + x0 * _omega_2 * cosh_omega_2_total) / _omega_2 - e * (_omega_2 * cosh_omega_2_total * u + _omega_2 * _omega_2 * x0 * sinh_omega_2_total) / _omega_2

			if _limit_overshooting and _stiffness != 0.0 and (p1 < position if p0 < p1 else position < p1):
				state.set_rest(k, true)
				state.set_position(k, p1)
				state.set_velocity(k, 0.0)
				continue

			# *3a
			var delta_ := p1 - position
			delta_sq += delta_ * delta_
			speed_sq += velocity * velocity
			at_rest = false

			state.set_position(k, position)
			state.set_velocity(k, velocity)

		# *3b
		if not at_rest and speed_sq <= _rest_speed_sq and delta_sq <= _rest_delta_sq:
			for j in state.get_element_size():
				var k: int = offset + j
				if state.get_rest(k):
					continue

				state.set_position(k, state.get_final_position(k))
				state.set_velocity(k, 0.0)
				state.set_rest(k, true)

		all_at_rest = at_rest and all_at_rest

	return null if all_at_rest else self

#-------------------------------------------------------------------------------

const _MAX_OMEGA_2_TOTAL := 350.0

var _total := 0.0
var _stiffness: float
var _rest_speed_sq: float
var _rest_delta_sq: float
var _limit_overshooting: bool
var _zeta: float
var _omega_0: float
var _omega_1: float
var _omega_2: float

func _init(
	stiffness: float,
	damping: float,
	mass: float,
	rest_delta: float,
	rest_speed: float,
	limit_overdamping: bool,
	limit_overshooting: bool) -> void:

	_stiffness = stiffness
	_rest_delta_sq = rest_delta * rest_delta
	_rest_speed_sq = rest_speed * rest_speed
	_limit_overshooting = limit_overshooting

	_zeta = damping / (2.0 * sqrt(_stiffness * mass))
	_omega_0 = sqrt(stiffness / mass)
	_omega_1 = _omega_0 * sqrt(1.0 - _zeta * _zeta)
	_omega_2 = _omega_0 * sqrt(_zeta * _zeta - 1.0)

	if limit_overdamping and 1.0 < _zeta:
		_zeta = 1.0
