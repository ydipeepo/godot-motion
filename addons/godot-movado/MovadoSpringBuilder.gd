class_name MovadoSpringBuilder extends MovadoBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_context():
	return _context

func build_generator_init(
	initial_position,
	final_position,
	initial_velocity) -> MovadoGeneratorInit:

	var generator_init := MovadoSpringGeneratorInit.new()
	generator_init.stiffness = _stiffness
	generator_init.damping = _damping
	generator_init.mass = _mass
	generator_init.rest_delta = _rest_delta
	generator_init.rest_speed = _rest_speed
	generator_init.limit_overdamping = _limit_overdamping
	generator_init.limit_overshooting = _limit_overshooting
	generator_init.initial_position = initial_position
	generator_init.final_position = final_position
	generator_init.initial_velocity = initial_velocity
	generator_init.delay = _delay
	return generator_init

# 剛性係数を設定します
func set_stiffness(value: float) -> MovadoSpringBuilder:
	assert(0.0 < value)
	_stiffness = value
	return self

# 減衰係数を設定します
func set_damping(value: float) -> MovadoSpringBuilder:
	assert(0.0 <= value)
	_damping = value
	return self

# (ばねの端にぶら下がっている) 物体の質量を設定します
func set_mass(value: float) -> MovadoSpringBuilder:
	assert(0.0 < value)
	_mass = value
	return self

# この速度を下回ると停止したとみなされる可能性があります。set_rest_delta() と両方の条件が揃うと停止します
func set_rest_speed(value: float) -> MovadoSpringBuilder:
	assert(0.0 < value)
	_rest_speed = value
	return self

# この距離を下回ると停止したとみなされる可能性があります。set_rest_speed() と両方の条件が揃うと停止します
func set_rest_delta(value: float) -> MovadoSpringBuilder:
	assert(0.0 < value)
	_rest_delta = value
	return self

# 過減衰とならないよう制限します
func set_limit_overdamping(value: bool) -> MovadoSpringBuilder:
	_limit_overdamping = value
	return self

# 停止位置をオーバーシュートしないよう制限します
func set_limit_overshooting(value: bool) -> MovadoSpringBuilder:
	_limit_overshooting = value
	return self

# 開始までの遅延を設定します
func set_delay(value: float) -> MovadoSpringBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

#-------------------------------------------------------------------------------

var _context

var _stiffness := MovadoSpringGeneratorInit.DEFAULT_STIFFNESS
var _damping := MovadoSpringGeneratorInit.DEFAULT_DAMPING
var _mass := MovadoSpringGeneratorInit.DEFAULT_MASS
var _rest_delta := MovadoSpringGeneratorInit.DEFAULT_REST_DELTA
var _rest_speed := MovadoSpringGeneratorInit.DEFAULT_REST_SPEED
var _limit_overdamping := MovadoSpringGeneratorInit.DEFAULT_LIMIT_OVERDAMPING
var _limit_overshooting := MovadoSpringGeneratorInit.DEFAULT_LIMIT_OVERSHOOTING
var _delay := 0.0

func _init(context) -> void:
	assert(context != null)

	_context = context
