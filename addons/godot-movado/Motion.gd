extends Node

#-------------------------------------------------------------------------------
# シグナル
#-------------------------------------------------------------------------------

# アニメーションが開始したとき発火します
signal started(object: Node, object_key: String)
# アニメーションが変化したとき発火します
signal updated(object: Node, object_key: String)
# アニメーションが完了したとき発火します
signal finished(object: Node, object_key: String)
# すべてのアニメーションが完了したとき発火します
signal all_finished

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# コンテキスト
var context: MovadoContext:
	get:
		return _context

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 指定したオブジェクトプロパティに対してバネアニメーションをアタッチします
func with(
	object: Node,
	object_property: NodePath) -> MovadoWithExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := MovadoSpringGeneratorInit.new()
	#_context.attach_processor
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return MovadoWithExpression.new(generator_init)

# 指定したオブジェクトメソッドに対してバネアニメーションをアタッチします
func with_method(
	object: Node,
	object_method: String) -> MovadoWithExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoSpringGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return MovadoWithExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対してバネアニメーションをアタッチします
func with_method_deferred(
	object: Node,
	object_method: String) -> MovadoWithExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoSpringGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return MovadoWithExpression.new(generator_init)

# 指定したオブジェクトプロパティに対して減衰アニメーションをアタッチします
func stop(
	object: Node,
	object_property: NodePath) -> MovadoStopExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := MovadoDecayGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return MovadoStopExpression.new(generator_init)

# 指定したオブジェクトメソッドに対して減衰アニメーションをアタッチします
func stop_method(
	object: Node,
	object_method: String) -> MovadoStopExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoDecayGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return MovadoStopExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対して減衰アニメーションをアタッチします
func stop_method_deferred(
	object: Node,
	object_method: String,
	decay_preset_or_preset_name = null) -> MovadoStopExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoDecayGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return MovadoStopExpression.new(generator_init)

# 指定したオブジェクトプロパティに対して Tween アニメーションをアタッチします
func ease(
	object: Node,
	object_property: NodePath) -> MovadoEaseExpression:

	assert(object != null)
	assert(object_property != null)

	var generator_init := MovadoTweenGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_PROPERTY,
		object,
		object_property,
		generator_init)
	return MovadoEaseExpression.new(generator_init)

# 指定したオブジェクトメソッドに対して Tween アニメーションをアタッチします
func ease_method(
	object: Node,
	object_method: String) -> MovadoEaseExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoTweenGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD,
		object,
		object_method,
		generator_init)
	return MovadoEaseExpression.new(generator_init)

# 指定したオブジェクトメソッド (call_deferred()) に対して Tween アニメーションをアタッチします
func ease_method_deferred(
	object: Node,
	object_method: String) -> MovadoEaseExpression:

	assert(object != null)
	assert(object_method != null)

	var generator_init := MovadoTweenGeneratorInit.new()
	_context.call_deferred(
		"attach_processor",
		MovadoContext.PROCESSOR_UPDATE_DEFAULT,
		MovadoContext.PROCESSOR_ATTACH_METHOD_DEFERRED,
		object,
		object_method,
		generator_init)
	return MovadoEaseExpression.new(generator_init)

#-------------------------------------------------------------------------------

var _context: MovadoContext

func _init() -> void:
	_context = MovadoContext.new(self)
	_context.started.connect(_on_started)
	_context.updated.connect(_on_updated)
	_context.finished.connect(_on_finished)
	_context.all_finished.connect(_on_all_finished)

func _process(delta: float) -> void:
	_context.compact()

static func _is_object_invalid(object: Node) -> bool:
	return not is_instance_valid(object) or object.is_queued_for_deletion()

func _on_started(object: Node, object_key: String) -> void:
	started.emit(object, object_key)

func _on_updated(object: Node, object_key: String) -> void:
	updated.emit(object, object_key)

func _on_finished(object: Node, object_key: String) -> void:
	finished.emit(object, object_key)

func _on_all_finished() -> void:
	all_finished.emit()
