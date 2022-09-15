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
# プロパティ
#-------------------------------------------------------------------------------

# コンテキスト
var context: MotionContext setget , _get_context

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 指定したオブジェクトプロパティに対してバネアニメーションをアタッチします
func with(
	object: Node,
	object_property: NodePath) -> WithMotionExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := SpringMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return WithMotionExpression.new(generator_init)

# 指定したオブジェクトメソッドに対してバネアニメーションをアタッチします
func with_method(
	object: Node,
	object_method: String) -> WithMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := SpringMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return WithMotionExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対してバネアニメーションをアタッチします
func with_method_deferred(
	object: Node,
	object_method: String) -> WithMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := SpringMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return WithMotionExpression.new(generator_init)

# 指定したオブジェクトプロパティに対して減衰アニメーションをアタッチします
func stop(
	object: Node,
	object_property: NodePath) -> StopMotionExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := DecayMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return StopMotionExpression.new(generator_init)

# 指定したオブジェクトメソッドに対して減衰アニメーションをアタッチします
func stop_method(
	object: Node,
	object_method: String) -> StopMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := DecayMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return StopMotionExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対して減衰アニメーションをアタッチします
func stop_method_deferred(
	object: Node,
	object_method: String,
	decay_preset_or_preset_name = null) -> StopMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := DecayMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return StopMotionExpression.new(generator_init)

# 指定したオブジェクトプロパティに対して Tween アニメーションをアタッチします
func ease(
	object: Node,
	object_property: NodePath) -> EaseMotionExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := TweenMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return EaseMotionExpression.new(generator_init)

# 指定したオブジェクトメソッドに対して Tween アニメーションをアタッチします
func ease_method(
	object: Node,
	object_method: String) -> EaseMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := TweenMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return EaseMotionExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対して Tween アニメーションをアタッチします
func ease_method_deferred(
	object: Node,
	object_method: String) -> EaseMotionExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := TweenMotionGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MotionContext.PROCESSOR_UPDATE_DEFAULT,
		MotionContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return EaseMotionExpression.new(generator_init)

#-------------------------------------------------------------------------------

func _get_context() -> MotionContext:
	return _context

var _context: MotionContext

func _init() -> void:
	_context = MotionContext.new(self)
	_context.connect("started", self, "_on_started")
	_context.connect("updated", self, "_on_updated")
	_context.connect("finished", self, "_on_finished")
	_context.connect("all_finished", self, "_on_all_finished")

func _process(delta: float) -> void:
	_context.compact()

static func _is_object_invalid(object: Node) -> bool:
	return not is_instance_valid(object) or object.is_queued_for_deletion()

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
