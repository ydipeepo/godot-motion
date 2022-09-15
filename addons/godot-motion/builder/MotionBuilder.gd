class_name MotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# コンテキストを取得します
func get_context():
	#
	# 継承先で実装します。
	#

	assert(false)
	return null

# プロセッサの更新モードを設定します
func set_processor_update(value: int):
	_processor_update = value
	return self

# 指定したオブジェクトプロパティに対してアニメーションをアタッチします
func start(
	target: Node,
	target_property: NodePath,
	initial_position = null,
	final_position = null,
	initial_velocity = null) -> MotionGeneratorInit:

	var generator_init := build_generator_init(
		initial_position,
		final_position,
		initial_velocity)
	get_context().attach_processor(
		_processor_update,
		0, # = MotionContext.PROCESSOR_ATTACH_PROPERTY
		target,
		target_property,
		generator_init)
	return generator_init

# 指定したオブジェクトメソッドに対してアニメーションをアタッチします
func start_method(
	target: Node,
	target_method: String,
	initial_position = null,
	final_position = null,
	initial_velocity = null) -> MotionGeneratorInit:

	var generator_init := build_generator_init(
		initial_position,
		final_position,
		initial_velocity)
	get_context().attach_processor(
		_processor_update,
		1, # = MotionContext.PROCESSOR_ATTACH_METHOD
		target,
		target_method,
		generator_init)
	return generator_init

# 指定したオブジェクトメソッド (call_deferred()) に対してアニメーションをアタッチします
func start_method_deferred(
	target: Node,
	target_method: String,
	initial_position = null,
	final_position = null,
	initial_velocity = null) -> MotionGeneratorInit:

	var generator_init := build_generator_init(
		initial_position,
		final_position,
		initial_velocity)
	get_context().attach_processor(
		_processor_update,
		2, # = MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED
		target,
		target_method,
		generator_init)
	return generator_init

# オプションに基づいて新たにイニシエータを作成します
func build_generator_init(
	initial_position,
	final_position,
	initial_velocity) -> MotionGeneratorInit:

	#
	# 継承先で実装する必要があります。
	#

	assert(false)
	return null

#-------------------------------------------------------------------------------

var _processor_update := 0 # = MotionContext.PROCESSOR_UPDATE_DEFAULT
