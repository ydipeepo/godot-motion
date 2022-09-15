class_name StopMotionExpression

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 最終位置をどれくらい離すかを設定します
func set_power(value: float) -> StopMotionExpression:
	assert(0.0 < value)
	_generator_init.power = value
	return self

# 時間定数を設定します
func set_time_constant(value: float) -> StopMotionExpression:
	assert(0.0 <= value)
	_generator_init.time_constant = value
	return self

# この距離を下回ると停止します
func set_rest_delta(value: float) -> StopMotionExpression:
	assert(0.0 < value)
	_generator_init.rest_delta = value
	return self

# 初期速度を優先するよう設定します
func prefer_velocity() -> StopMotionExpression:
	_generator_init.prefer = DecayMotionGeneratorInit.PREFER_VELOCITY
	return self

# 最終位置を優先するよう設定します
func prefer_position() -> StopMotionExpression:
	_generator_init.prefer = DecayMotionGeneratorInit.PREFER_POSITION
	return self

# 開始までの遅延を設定します
func delay(value: float) -> StopMotionExpression:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> StopMotionExpression:
	_generator_init.delay = 0.0
	return self

# 初期位置を設定します
func from(position) -> StopMotionExpression:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position, auto_prefer := true) -> StopMotionExpression:
	_generator_init.final_position = position
	if auto_prefer:
		_generator_init.prefer = DecayMotionGeneratorInit.PREFER_POSITION
	return self

# 初期速度を設定します
func by(velocity, auto_prefer := true) -> StopMotionExpression:
	_generator_init.initial_velocity = velocity
	if auto_prefer:
		_generator_init.prefer = DecayMotionGeneratorInit.PREFER_VELOCITY
	return self

#-------------------------------------------------------------------------------

var _generator_init: DecayMotionGeneratorInit

func _init(generator_init: DecayMotionGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
	.call_deferred("free")
