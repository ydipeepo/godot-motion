class_name MovadoDecayBuilder extends MovadoBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_context():
	return _context

func build_generator_init(
	initial_position,
	final_position,
	initial_velocity) -> MovadoGeneratorInit:

	var generator_init := MovadoDecayGeneratorInit.new()
	generator_init.prefer = _prefer
	generator_init.power = _power
	generator_init.time_constant = _time_constant
	generator_init.rest_delta = _rest_delta
	generator_init.initial_position = initial_position
	generator_init.final_position = final_position
	generator_init.initial_velocity = initial_velocity
	generator_init.delay = _delay
	return generator_init

# 最終位置をどれくらい離すかを設定します
func set_power(value: float) -> MovadoDecayBuilder:
	assert(0.0 < value)
	_power = value
	return self

# 時間定数を設定します
func set_time_constant(value: float) -> MovadoDecayBuilder:
	assert(0.0 <= value)
	_time_constant = value
	return self

# この距離を下回ると停止します
func set_rest_delta(value: float) -> MovadoDecayBuilder:
	assert(0.0 < value)
	_rest_delta = value
	return self

# 初期速度もしくは最終位置のうちどちらを優先するか設定します
func set_prefer(value: int) -> MovadoDecayBuilder:
	_prefer = value
	return self

# 開始までの遅延を設定します
func set_delay(value: float) -> MovadoDecayBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

#-------------------------------------------------------------------------------

var _context

var _prefer := MovadoDecayGeneratorInit.DEFAULT_PREFER
var _power := MovadoDecayGeneratorInit.DEFAULT_POWER
var _time_constant := MovadoDecayGeneratorInit.DEFAULT_TIME_CONSTANT
var _rest_delta := MovadoDecayGeneratorInit.DEFAULT_REST_DELTA
var _delay := 0.0

func _init(context) -> void:
	assert(context != null)

	_context = context
