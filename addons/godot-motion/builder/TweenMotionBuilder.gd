class_name TweenMotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# アニメーション期間を設定します
func set_duration(value: float) -> TweenMotionBuilder:
	assert(0.0 <= value)
	_duration = value
	return self

# イージングタイプを設定します
func set_ease(ease_type: int) -> TweenMotionBuilder:
	_ease_type = ease_type
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> TweenMotionBuilder:
	_trans_type = trans_type
	return self

# 開始までの遅延を設定します
func delay(value: float) -> TweenMotionBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> TweenMotionBuilder:
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
var _duration := 0.35
var _ease_type := Tween.EASE_IN_OUT
var _trans_type := Tween.TRANS_LINEAR
var _delay := 0.0

func _init(context: MotionContext) -> void:
	assert(context != null)

	_context = context

func _create_generator_init() -> MotionGeneratorInit:
	var generator_init := TweenMotionGeneratorInit.new()
	generator_init.duration = _duration
	generator_init.ease_type = _ease_type
	generator_init.trans_type = _trans_type
	generator_init.delay = _delay
	return generator_init
