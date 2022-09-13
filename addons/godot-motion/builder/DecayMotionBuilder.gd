class_name DecayMotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 最終位置をどれくらい離すかを設定します
func set_power(value: float) -> DecayMotionBuilder:
	assert(0.0 < value)
	_power = value
	return self

# アニメーション期間を設定します
func set_duration(value: float) -> DecayMotionBuilder:
	assert(0.0 <= value)
	_duration = value
	return self

# この距離を下回ると停止します
func set_rest_delta(value: float) -> DecayMotionBuilder:
	assert(0.0 < value)
	_rest_delta = value
	return self

# 初期速度を優先するよう設定します
func prefer_velocity() -> DecayMotionBuilder:
	_prefer = DecayMotionGeneratorInit.PREFER_VELOCITY
	return self

# 最終位置を優先するよう設定します
func prefer_position() -> DecayMotionBuilder:
	_prefer = DecayMotionGeneratorInit.PREFER_POSITION
	return self

# 開始までの遅延を設定します
func delay(value: float) -> DecayMotionBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> DecayMotionBuilder:
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
var _prefer := DecayMotionGeneratorInit.PREFER_VELOCITY
var _power := 0.8
var _duration := 0.35
var _rest_delta := 0.001
var _delay := 0.0

func _init(context: MotionContext) -> void:
	assert(context != null)

	_context = context

func _create_generator_init() -> MotionGeneratorInit:
	var generator_init := DecayMotionGeneratorInit.new()
	generator_init.prefer = _prefer
	generator_init.power = _power
	generator_init.duration = _duration
	generator_init.rest_delta = _rest_delta
	generator_init.delay = _delay
	return generator_init
