class_name MotionProcessor extends Node

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
var state: MotionState
# ステートが休止状態かどうか
var is_all_rest: bool setget , _get_is_all_rest
# このプロセッサがキャッシュ期間内かどうか
var is_expiring: bool setget , _get_is_expiring
# このプロセッサがキャッシュ期間を満了しているかどうか
var is_expired: bool setget , _get_is_expired

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 指定したジェネレータによるアニメーションを開始します
func start(
	generator_init: MotionGeneratorInit,
	cache_duration: float) -> void:

	assert(generator_init != null)
	assert(0.0 <= cache_duration)

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
	_cache_duration = cache_duration
	_cache_timer = 0.0

# 解放するよう要求します
func queue_free() -> void:
	.queue_free()

	match _process_state:
		_PROCESS_STATE_STARTING:
			pass
		_PROCESS_STATE_STARTING_WITHOUT_SIGNAL:
			pass
		_PROCESS_STATE_UPDATING:
			.emit_signal("finished")
		_PROCESS_STATE_FINISHING:
			.emit_signal("finished")
		_PROCESS_STATE_EXPIRING:
			pass
		_PROCESS_STATE_EXPIRED:
			assert(false, "Call free() instead.")

	_process_state = _PROCESS_STATE_EXPIRED
	.set_process(false)
	.set_physics_process(false)

#-------------------------------------------------------------------------------

func _get_is_all_rest() -> bool:
	return MotionStateHelper.get_rest(state)

func _get_is_expiring() -> bool:
	return _process_state >= _PROCESS_STATE_EXPIRING

func _get_is_expired() -> bool:
	return _process_state >= _PROCESS_STATE_EXPIRED

enum {
	_PROCESS_STATE_STARTING,
	_PROCESS_STATE_STARTING_WITHOUT_SIGNAL,
	_PROCESS_STATE_UPDATING,
	_PROCESS_STATE_FINISHING,
	_PROCESS_STATE_EXPIRING,
	_PROCESS_STATE_EXPIRED,
}

var _process_state := _PROCESS_STATE_STARTING
var _generator_init: MotionGeneratorInit
var _generator: MotionGenerator
var _cache_duration := 0.0
var _cache_timer := 0.0

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
	.set_process(false)
	.set_physics_process(false)

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
			.emit_signal("updated")

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
				.emit_signal("started")
			return delay_overlap

		_process_state = _PROCESS_STATE_EXPIRING

	return null

func _handle_update(delta: float):
	assert(_process_state == _PROCESS_STATE_UPDATING)
	assert(_generator_init == null)
	assert(_generator != null)

	_generator = _generator.next(state, delta)

	if _generator != null:
		.emit_signal("updated")
		return null

	_process_state = _PROCESS_STATE_FINISHING
	return 0.0

func _handle_finish(delta: float):
	assert(_process_state == _PROCESS_STATE_FINISHING)
	assert(_generator_init == null)
	assert(_generator == null)

	_process_state = _PROCESS_STATE_EXPIRING
	.emit_signal("finished")
	return delta

func _handle_expire(delta: float):
	assert(_process_state == _PROCESS_STATE_EXPIRING)
	assert(_generator_init == null)
	assert(_generator == null)

	_cache_timer += delta
	if _cache_duration <= _cache_timer:
		_process_state = _PROCESS_STATE_EXPIRED
		return 0.0

	return null

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: UNUSED_SIGNAL
