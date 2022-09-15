class_name MotionContext

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
	# プロセッサはオブジェクトプロパティにアタッチされます
	PROCESSOR_ATTACH_PROPERTY,
	# プロセッサはオブジェクトメソッドにアタッチされます
	PROCESSOR_ATTACH_METHOD,
	# プロセッサはオブジェクトメソッド (call_deferred()) にアタッチされます
	PROCESSOR_ATTACH_METHOD_DEFERRED,
}

enum {
	# プロセッサは _process により処理を行います
	PROCESSOR_UPDATE_DEFAULT,
	# プロセッサは _physics_process により処理を行います
	PROCESSOR_UPDATE_PHYSICS,
}

enum {
	# 跳ね返りのない標準的な動きのバネアニメーションプリセット (stiff=170, damping=26)
	SPRING_STANDARD,
	# 優しめの動きのバネアニメーションプリセット (stiff=120, damping=14)
	SPRING_GENTLE,
	# ぐらついたような動きのバネアニメーションプリセット (stiff=210, damping=20)
	SPRING_WOBBLY,
	# 硬めの動きのバネアニメーションプリセット (stiff=210, damping=60)
	SPRING_STIFF,
	# 遅めの動きのバネアニメーションプリセット (stiff=280, damping=60)
	SPRING_SLOW,
	# 蜜が滴るような動きのバネアニメーションプリセット (stiff=280, damping=120)
	SPRING_MOLASSES,
}

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# プロセッサのキャッシュ期間
var processor_cache_duration: float setget _set_processor_cache_duration, _get_processor_cache_duration
# プロセッサ数
var processor_count: int setget , _get_processor_count

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 現在のステートを取得します
func get_state(
	processor_attach: int,
	target: Node,
	target_property: NodePath) -> MotionState:

	assert(target != null)
	assert(target_property != null)

	var processor := _get_processor(target, target_property, processor_attach)
	return processor.state if processor != null and not processor.is_expired else null

# バネアニメーションのビルダを作成します
func create_spring(preset = null) -> SpringMotionBuilder:
	assert(preset == null or typeof(preset) == TYPE_INT)

	var builder := SpringMotionBuilder.new(self)
	match preset:
		SPRING_STANDARD:
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
	return builder

# 減衰アニメーションのビルダを作成します
func create_decay() -> DecayMotionBuilder:
	return DecayMotionBuilder.new(self)

# Tween アニメーションのビルダを作成します
func create_tween() -> TweenMotionBuilder:
	return TweenMotionBuilder.new(self)

# 指定したオブジェクトに対してアニメーションをアタッチします
func attach_processor(
	processor_update: int,
	processor_attach: int,
	target: Node,
	target_key: String,
	generator_init: MotionGeneratorInit) -> void:

	if _is_object_invalid(target):
		return

	var processor := _get_processor(target, target_key, processor_attach)
	var processor_exists := processor != null

	if not processor_exists:
		processor = MotionProcessor.new()
		processor.name = _create_processor_name(target, target_key, processor_attach)
		processor.connect("started", self, "_on_processor_started", [target, target_key, processor, processor_attach])
		processor.connect("updated", self, "_on_processor_updated", [target, target_key, processor, processor_attach])
		processor.connect("finished", self, "_on_processor_finished", [target, target_key, processor, processor_attach])

	match processor_attach:
		PROCESSOR_ATTACH_PROPERTY:
			if (generator_init.initial_position == null or
				generator_init.final_position == null):

				if 0.0 < generator_init.delay:
					var position_binder := MotionDelayedPosition.new(target, target_key)
					if generator_init.initial_position == null:
						generator_init.initial_position = position_binder
					if generator_init.final_position == null:
						generator_init.final_position = position_binder
				else:
					var position = target.get_indexed(target_key)
					if generator_init.initial_position == null:
						generator_init.initial_position = position
					if generator_init.final_position == null:
						generator_init.final_position = position

			if not processor_exists:
				processor.state = MotionStateHelper.create(generator_init.initial_position)

		PROCESSOR_ATTACH_METHOD, PROCESSOR_ATTACH_METHOD_DEFERRED:
			if not processor_exists:
				assert(
					generator_init.initial_position != null or
					generator_init.final_position != null)

				var position
				if generator_init.initial_position != null:
					position = generator_init.initial_position
				if generator_init.final_position != null:
					position = generator_init.final_position
				processor.state = MotionStateHelper.create(position)

				if generator_init.initial_position == null:
					generator_init.initial_position = processor.state.get_zero()
				if generator_init.final_position == null:
					generator_init.final_position = processor.state.get_one()

	processor.start(generator_init, _processor_cache_duration)

	if processor_exists:
		_container.move_child(processor, _container.get_child_count())

	else:
		_container.add_child(processor)

	match processor_update:
		PROCESSOR_UPDATE_DEFAULT:
			processor.set_process(true)
			processor.set_physics_process(false)
		PROCESSOR_UPDATE_PHYSICS:
			processor.set_process(false)
			processor.set_physics_process(true)
		_:
			assert(false)

# 指定したオブジェクトに対してアタッチされたアニメーションを取り除きます
func detach_processor(
	processor_attach: int,
	target: Node,
	target_key: String) -> void:

	if _is_object_invalid(target):
		return

	var processor := _get_processor(target, target_key, processor_attach)
	if processor != null and not processor.is_queued_for_deletion():
		if processor.is_expired:
			processor.free()
		else:
			processor.queue_free()

# キャッシュ期間が経過したプロセッサを解放します
func compact() -> void:
	var index := _container.get_child_count()
	while index > 0:
		index -= 1
		var processor := _container.get_child(index) as MotionProcessor
		if processor != null and processor.is_expired:
			processor.free()

#-------------------------------------------------------------------------------

func _set_processor_cache_duration(value: float) -> void:
	assert(0.0 <= value)
	_processor_cache_duration = value

func _get_processor_cache_duration() -> float:
	return _processor_cache_duration

func _get_processor_count() -> int:
	return _processor_count

var _container: Node
var _processor_cache_duration := 8.0
var _processor_count := 0

func _init(container: Node) -> void:
	assert(container != null)

	_container = container

static func _is_object_invalid(object: Node) -> bool:
	return not is_instance_valid(object) or object.is_queued_for_deletion()

static func _create_processor_name(
	object: Node,
	object_key: String,
	processor_attach: int) -> String:

	assert(object != null)
	assert(object_key != null)

	var processor_name: String
	match processor_attach:
		PROCESSOR_ATTACH_PROPERTY:
			processor_name = "Prop_%s_at_%d" % [
				object_key.replace(":", "__").replace(".", "_").replace("/", "_"),
				object.get_instance_id(),
			]
		PROCESSOR_ATTACH_METHOD, PROCESSOR_ATTACH_METHOD_DEFERRED:
			processor_name = "Call_%s_at_%d" % [
				object_key.replace(":", "__").replace(".", "_").replace("/", "_"),
				object.get_instance_id(),
			]
		_:
			assert(false)
	return processor_name

func _get_processor(
	object: Node,
	object_key: String,
	processor_attach: int) -> MotionProcessor:

	assert(object != null)
	assert(object_key != null)

	var processor_name := _create_processor_name(object, object_key, processor_attach)
	var index := _container.get_child_count()
	while index > 0:
		index -= 1
		var processor := _container.get_child(index) as MotionProcessor
		if processor != null and processor.name == processor_name:
			if not processor.is_expired:
				return processor
			processor.free()
	return null

func _on_processor_started(
	target: Node,
	target_key: String,
	processor: MotionProcessor,
	processor_attach: int) -> void:

	_processor_count += 1

	if _is_object_invalid(target):
		processor.queue_free()

	else:
		match processor_attach:
			PROCESSOR_ATTACH_PROPERTY:
				target.set_indexed(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD:
				target.call(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD_DEFERRED:
				target.call_deferred(target_key, processor.state.position)

	.emit_signal("started", target, target_key)

func _on_processor_updated(
	target: Node,
	target_key: String,
	processor: MotionProcessor,
	processor_attach: int) -> void:

	if _is_object_invalid(target):
		processor.queue_free()

	else:
		match processor_attach:
			PROCESSOR_ATTACH_PROPERTY:
				target.set_indexed(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD:
				target.call(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD_DEFERRED:
				target.call_deferred(target_key, processor.state.position)

	.emit_signal("updated", target, target_key)

func _on_processor_finished(
	target: Node,
	target_key: String,
	processor: MotionProcessor,
	processor_attach: int) -> void:

	_processor_count -= 1
	assert(0 <= _processor_count)

	if _is_object_invalid(target):
		processor.queue_free()

	else:
		match processor_attach:
			PROCESSOR_ATTACH_PROPERTY:
				target.set_indexed(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD:
				target.call(target_key, processor.state.position)
			PROCESSOR_ATTACH_METHOD_DEFERRED:
				target.call_deferred(target_key, processor.state.position)

	.emit_signal("finished", target, target_key)

	if _processor_count == 0:
		.emit_signal("all_finished")
