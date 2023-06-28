class_name MovadoProcessor extends Node

#-------------------------------------------------------------------------------
# シグナル
#-------------------------------------------------------------------------------

# アニメーションが開始したとき発火します
signal started
# アニメーションが変化したとき発火します
signal updated
# アニメーションが完了したとき発火します
signal finished

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# ステート
var state: MovadoState
# ステートが休止状態かどうか
var is_all_rest: bool:
	get:
		return MovadoStateHelper.get_rest(state)
# このプロセッサがリテンション期間内かどうか
var is_expiring: bool:
	get:
		return _process_state >= _PROCESS_STATE_EXPIRING
# このプロセッサがリテンション期間を満了しているかどうか
var is_expired: bool:
	get:
		return _process_state >= _PROCESS_STATE_EXPIRED

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 指定したジェネレータによるアニメーションを開始します
func start(
	generator_init: MovadoGeneratorInit,
	retention_duration: float) -> void:

	assert(generator_init != null)
	assert(0.0 <= retention_duration)

	match _process_state:
		_PROCESS_STATE_STARTING:
			pass
		_PROCESS_STATE_STARTING_WITHOUT_SIGNAL:
			pass
		_PROCESS_STATE_UPDATING:
			_process_state = _PROCESS_STATE_STARTING_WITHOUT_SIGNAL
		_PROCESS_STATE_FINISHING:
			assert(false)
		_PROCESS_STATE_EXPIRING:
			_process_state = _PROCESS_STATE_STARTING
		_PROCESS_STATE_EXPIRED:
			assert(false)

	_generator_init = generator_init
	_retention_duration = retention_duration
	_retention_timer = 0.0

# 解放するよう要求します
func queue_free() -> void:
	super.queue_free()

	match _process_state:
		_PROCESS_STATE_STARTING:
			pass
		_PROCESS_STATE_STARTING_WITHOUT_SIGNAL:
			pass
		_PROCESS_STATE_UPDATING:
			finished.emit()
		_PROCESS_STATE_FINISHING:
			finished.emit()
		_PROCESS_STATE_EXPIRING:
			pass
		_PROCESS_STATE_EXPIRED:
			assert(false, "Call free() instead.")

	_process_state = _PROCESS_STATE_EXPIRED
	super.set_process(false)
	super.set_physics_process(false)

#-------------------------------------------------------------------------------

enum {
	_PROCESS_STATE_STARTING,
	_PROCESS_STATE_STARTING_WITHOUT_SIGNAL,
	_PROCESS_STATE_UPDATING,
	_PROCESS_STATE_FINISHING,
	_PROCESS_STATE_EXPIRING,
	_PROCESS_STATE_EXPIRED,
}

var _process_state := _PROCESS_STATE_STARTING
var _generator_init: MovadoGeneratorInit
var _generator: MovadoGenerator
var _retention_duration := 0.0
var _retention_timer := 0.0

func _ready() -> void:
	assert(state != null)

func _process(delta: float) -> void:
	_handle(delta)

func _physics_process(delta: float) -> void:
	_handle(delta)

func _handle(delta) -> void:
	assert(_process_state != _PROCESS_STATE_EXPIRED)

	if _process_state == _PROCESS_STATE_STARTING:
		delta = _handle_start(delta, true)
		if delta == null:
			return

	if _process_state == _PROCESS_STATE_STARTING_WITHOUT_SIGNAL:
		delta = _handle_start(delta, false)
		if delta == null:
			return

	if _process_state == _PROCESS_STATE_UPDATING:
		delta = _handle_update(delta)
		if delta == null:
			return

	if _process_state == _PROCESS_STATE_FINISHING:
		delta = _handle_finish(delta)
		if delta == null:
			return

	if _process_state == _PROCESS_STATE_EXPIRING:
		delta = _handle_expire(delta)
		if delta == null:
			return

	assert(_process_state == _PROCESS_STATE_EXPIRED)
	super.set_process(false)
	super.set_physics_process(false)

func _handle_start(
	delta: float,
	emit_started: bool):

	assert(
		_process_state == _PROCESS_STATE_STARTING or
		_process_state == _PROCESS_STATE_STARTING_WITHOUT_SIGNAL)
	assert(_generator_init != null)

	var delay_reminder := _generator_init.delay - delta
	if 0.0 < delay_reminder:
		_generator_init.delay = delay_reminder
		if _generator != null:
			_generator = _generator.next(state, delta)
			updated.emit()

	else:
		var delay_overlap := -delay_reminder
		_generator_init.delay = 0.0

		if _generator != null:
			var delta_reminder := delta - delay_overlap
			if 0.0 < delta_reminder:
				_generator.next(state, delta_reminder)

		_generator = _generator_init.init(state, _generator)
		_generator_init = null

		if _generator != null:
			_process_state = _PROCESS_STATE_UPDATING
			if emit_started:
				started.emit()
			return delay_overlap

		_process_state = _PROCESS_STATE_EXPIRING

	return null

func _handle_update(delta: float):
	assert(_process_state == _PROCESS_STATE_UPDATING)
	assert(_generator_init == null)
	assert(_generator != null)

	_generator = _generator.next(state, delta)

	if _generator != null:
		updated.emit()
		return null

	_process_state = _PROCESS_STATE_FINISHING
	return 0.0

func _handle_finish(delta: float):
	assert(_process_state == _PROCESS_STATE_FINISHING)
	assert(_generator_init == null)
	assert(_generator == null)

	_process_state = _PROCESS_STATE_EXPIRING
	finished.emit()
	return delta

func _handle_expire(delta: float):
	assert(_process_state == _PROCESS_STATE_EXPIRING)
	assert(_generator_init == null)
	assert(_generator == null)

	_retention_timer += delta
	if _retention_duration <= _retention_timer:
		_process_state = _PROCESS_STATE_EXPIRED
		return 0.0

	return null
