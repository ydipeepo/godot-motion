extends Node

#-------------------------------------------------------------------------------
# シグナル
#-------------------------------------------------------------------------------

# アニメーションが開始したとき発火します
signal started(object, object_key)
# アニメーションが変化したとき発火します
signal updated(object, object_key)
# アニメーションが完了したとき発火します
signal finished(object, object_key)
# すべてのアニメーションが完了したとき発火します
signal all_finished

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

enum {
	# デフォルト (stiff=170, damping=26)
	SPRING_DEFAULT,
	# 優しめの動き (stiff=120, damping=14)
	SPRING_GENTLE,
	# ぐらついたような動き (stiff=210, damping=20)
	SPRING_WOBBLY,
	# 硬めの動き (stiff=210, damping=60)
	SPRING_STIFF,
	# 遅めの動き (stiff=280, damping=60)
	SPRING_SLOW,
	# 蜜が滴るような動き (stiff=280, damping=120)
	SPRING_MOLASSES,
}

enum {
	# デフォルト (power=0.8, duration=0.35)
	DECAY_DEFAULT,
	# すばやい静止 (power=0.2, duration=0.15)
	DECAY_FAST,
	# ゆっくりした静止 (power=0.9, duration=0.75)
	DECAY_SLOW,
}

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# コンテキスト
var context: MotionContext setget , _get_context

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# バネアニメーションのプリセットを登録します
func register_spring_preset(
	preset_name: String,
	generator_init: SpringMotionGeneratorInit) -> bool:

	if preset_name in _spring_preset_map:
		return false

	_spring_preset_map[preset_name] = generator_init
	return true

# バネアニメーションのプリセットを削除します
func unregister_spring_preset(preset_name: String) -> void:
	assert(preset_name in _spring_preset_map)
	_spring_preset_map.erase(preset_name)

# 減衰アニメーションのプリセットを登録します
func register_decay_preset(
	preset_name: String,
	generator_init: DecayMotionGeneratorInit) -> bool:

	if preset_name in _decay_preset_map:
		return false

	_decay_preset_map[preset_name] = generator_init
	return true

# 減衰アニメーションのプリセットを削除します
func unregister_decay_preset(preset_name: String) -> void:
	assert(preset_name in _decay_preset_map)
	_decay_preset_map.erase(preset_name)

# バネアニメーションのビルダを作成します
func create_spring(preset_or_preset_name = null) -> SpringMotionBuilder:
	return _set_spring_preset(
		SpringMotionBuilder.new(_context),
		preset_or_preset_name)

# 減衰アニメーションのビルダを作成します
func create_decay(preset_or_preset_name = null) -> DecayMotionBuilder:
	return _set_decay_preset(
		DecayMotionBuilder.new(_context),
		preset_or_preset_name)

# 指定したオブジェクトプロパティに対してバネアニメーションをアタッチします
func with(
	object: Node,
	object_property: NodePath,
	spring_preset_or_preset_name = null) -> WithMotionBuilder:

	assert(object != null)
	assert(object_property != null)

	var generator_init := SpringMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init,
	])

	return _set_spring_preset(
		WithMotionBuilder.new(generator_init),
		spring_preset_or_preset_name)

# 指定したオブジェクトメソッドに対してバネアニメーションをアタッチします
func with_method(
	object: Node,
	object_method: String,
	spring_preset_or_preset_name = null) -> WithMotionBuilder:

	assert(object != null)
	assert(object_method != null)

	var generator_init := SpringMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init,
	])

	return _set_spring_preset(
		WithMotionBuilder.new(generator_init),
		spring_preset_or_preset_name)

# 指定したオブジェクトメソッド (call_deferred()) に対してバネアニメーションをアタッチします
func with_method_deferred(
	object: Node,
	object_method: String,
	spring_preset_or_preset_name = null) -> WithMotionBuilder:

	assert(object != null)
	assert(object_method != null)

	var generator_init := SpringMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init,
	])

	return _set_spring_preset(
		WithMotionBuilder.new(generator_init),
		spring_preset_or_preset_name)

# 指定したオブジェクトプロパティに対して減衰アニメーションをアタッチします
func stop(
	object: Node,
	object_property: NodePath,
	decay_preset_or_preset_name = null) -> StopMotionBuilder:

	assert(object != null)
	assert(object_property != null)

	var generator_init := DecayMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init,
	])

	return _set_decay_preset(
		StopMotionBuilder.new(generator_init),
		decay_preset_or_preset_name)

# 指定したオブジェクトメソッドに対して減衰アニメーションをアタッチします
func stop_method(
	object: Node,
	object_method: String,
	decay_preset_or_preset_name = null) -> StopMotionBuilder:

	assert(object != null)
	assert(object_method != null)

	var generator_init := DecayMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init,
	])

	return _set_decay_preset(
		StopMotionBuilder.new(generator_init),
		decay_preset_or_preset_name)

# 指定したオブジェクトメソッド (call_deferred()) に対して減衰アニメーションをアタッチします
func stop_method_deferred(
	object: Node,
	object_method: String,
	decay_preset_or_preset_name = null) -> StopMotionBuilder:

	assert(object != null)
	assert(object_method != null)

	var generator_init := DecayMotionGeneratorInit.new()

	_context_start_args_list.append([
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init,
	])

	return _set_decay_preset(
		StopMotionBuilder.new(generator_init),
		decay_preset_or_preset_name)

#-------------------------------------------------------------------------------

func _get_context() -> MotionContext:
	return _context

var _context: MotionContext
var _context_start_args_list := []
var _spring_preset_map := {}
var _decay_preset_map := {}

func _init() -> void:
	_context = MotionContext.new(self)
	_context.connect("started", self, "_on_started")
	_context.connect("updated", self, "_on_updated")
	_context.connect("finished", self, "_on_finished")
	_context.connect("all_finished", self, "_on_all_finished")

func _process(delta: float) -> void:
	for args in _context_start_args_list:
		var processor_attach: int = args[0]
		var target: Node = args[1]
		var target_key: String = args[2]
		var generator_init: MotionGeneratorInit = args[3]

		if _is_object_invalid(target):
			continue

		_context.start(
			processor_attach,
			target,
			target_key,
			generator_init)

	_context_start_args_list.clear()

	_context.compact()

static func _is_object_invalid(object: Node) -> bool:
	return not is_instance_valid(object) or object.is_queued_for_deletion()

func _set_spring_preset(
	builder,
	preset_or_preset_name):

	match typeof(preset_or_preset_name):
		TYPE_NIL:
			pass

		TYPE_STRING:
			assert(preset_or_preset_name in _spring_preset_map)
			var generator_init: SpringMotionGeneratorInit = _spring_preset_map[preset_or_preset_name]
			builder.set_stiffness(generator_init.stiffness)
			builder.set_damping(generator_init.damping)
			builder.set_mass(generator_init.mass)
			builder.set_rest_delta(generator_init.rest_delta)
			builder.set_rest_speed(generator_init.rest_speed)
			if generator_init.limit_overdamping:
				builder.limit_overdamping()
			if generator_init.limit_overshooting:
				builder.limit_overshooting()

		TYPE_INT:
			match preset_or_preset_name:
				SPRING_DEFAULT:
					builder.set_stiffness(170.0).set_damping(26.0)
				SPRING_GENTLE:
					builder.set_stiffness(120.0).set_damping(14.0)
				SPRING_WOBBLY:
					builder.set_stiffness(180.0).set_damping(12.0)
				SPRING_STIFF:
					builder.set_stiffness(210.0).set_damping(20.0)
				SPRING_SLOW:
					builder.set_stiffness(280.0).set_damping(60.0)
				SPRING_MOLASSES:
					builder.set_stiffness(280.0).set_damping(120.0)
				_:
					assert(false)

		_:
			assert(false)

	return builder

func _set_decay_preset(
	builder,
	preset_or_preset_name):

	match typeof(preset_or_preset_name):
		TYPE_NIL:
			pass

		TYPE_STRING:
			assert(preset_or_preset_name in _decay_preset_map)
			var generator_init: DecayMotionGeneratorInit = _decay_preset_map[preset_or_preset_name]
			builder.set_power(generator_init.power)
			builder.set_duration(generator_init.duration)
			builder.set_rest_delta(generator_init.rest_delta)
			match generator_init.prefer:
				DecayMotionGeneratorInit.PREFER_VELOCITY:
					builder.prefer_velocity()
				DecayMotionGeneratorInit.PREFER_POSITION:
					builder.prefer_position()

		TYPE_INT:
			match preset_or_preset_name:
				DECAY_DEFAULT:
					builder.set_power(0.8).set_duration(0.35)
				DECAY_FAST:
					builder.set_power(0.6).set_duration(0.15)
				DECAY_SLOW:
					builder.set_power(0.9).set_duration(0.55)
				_:
					assert(false)

		_:
			assert(false)

	return builder

func _on_started(object: Node, object_key: String) -> void:
	.emit_signal("started", object, object_key)

func _on_updated(object: Node, object_key: String) -> void:
	.emit_signal("updated", object, object_key)

func _on_finished(object: Node, object_key: String) -> void:
	.emit_signal("finished", object, object_key)

func _on_all_finished() -> void:
	.emit_signal("all_finished")

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT
