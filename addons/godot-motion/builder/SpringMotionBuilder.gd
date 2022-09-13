class_name SpringMotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 剛性係数を設定します
func set_stiffness(value: float) -> SpringMotionBuilder:
	assert(0.0 < value)
	_stiffness = value
	return self

# 減衰係数を設定します
func set_damping(value: float) -> SpringMotionBuilder:
	assert(0.0 <= value)
	_damping = value
	return self

# (ばねの端にぶら下がっている) 物体の質量を設定します
func set_mass(value: float) -> SpringMotionBuilder:
	assert(0.0 < value)
	_mass = value
	return self

# この速度を下回ると停止したとみなされる可能性があります。set_rest_delta() と両方の条件が揃うと停止します
func set_rest_speed(value: float) -> SpringMotionBuilder:
	assert(0.0 < value)
	_rest_speed = value
	return self

# この距離を下回ると停止したとみなされる可能性があります。set_rest_speed() と両方の条件が揃うと停止します
func set_rest_delta(value: float) -> SpringMotionBuilder:
	assert(0.0 < value)
	_rest_delta = value
	return self

# 過減衰とならないよう制限します
func limit_overdamping() -> SpringMotionBuilder:
	_limit_overdamping = true
	return self

# limit_overdamping() で設定した制限を解除します
func unlimit_overdamping() -> SpringMotionBuilder:
	_limit_overdamping = false
	return self

# 停止位置をオーバーシュートしないよう制限します
func limit_overshooting() -> SpringMotionBuilder:
	_limit_overshooting = true
	return self

# limit_overshooting() で設定した制限を解除します
func unlimit_overshooting() -> SpringMotionBuilder:
	_limit_overshooting = false
	return self

# 開始までの遅延を設定します
func delay(value: float) -> SpringMotionBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> SpringMotionBuilder:
	_delay = 0.0
	return self

# 指定したオブジェクトプロパティに対してバネアニメーションをアタッチします
func start(
	target: Node,
	target_property: NodePath,
	initial_position,
	final_position,
	initial_velocity) -> void:

	_context.attach(
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		target,
		target_property,
		_create_generator_init())

# 指定したオブジェクトメソッドに対してバネアニメーションをアタッチします
func start_method(
	target: Node,
	target_method: String,
	initial_position,
	final_position,
	initial_velocity) -> void:

	_context.attach(
		MotionContext.PROCESSOR_ATTACH_METHOD,
		target,
		target_method,
		_create_generator_init())

# 指定したオブジェクトメソッド (call_deferred()) に対してバネアニメーションをアタッチします
func start_method_deferred(
	target: Node,
	target_method: String,
	initial_position,
	final_position,
	initial_velocity) -> void:

	_context.attach(
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		target,
		target_method,
		_create_generator_init())

#-------------------------------------------------------------------------------

var _context: MotionContext
var _stiffness := 100.0
var _damping := 10.0
var _mass := 1.0
var _rest_delta := 0.001
var _rest_speed := 0.001
var _limit_overdamping := false
var _limit_overshooting := false
var _delay := 0.0

func _init(context: MotionContext) -> void:
	assert(context != null)

	_context = context

func _create_generator_init() -> MotionGeneratorInit:
	var generator_init := SpringMotionGeneratorInit.new()
	generator_init.stiffness = _stiffness
	generator_init.damping = _damping
	generator_init.mass = _mass
	generator_init.rest_delta = _rest_delta
	generator_init.rest_speed = _rest_speed
	generator_init.limit_overdamping = _limit_overdamping
	generator_init.limit_overshooting = _limit_overshooting
	generator_init.delay = _delay
	return generator_init
