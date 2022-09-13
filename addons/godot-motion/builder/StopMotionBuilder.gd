class_name StopMotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 最終位置をどれくらい離すかを設定します
func set_power(value: float) -> StopMotionBuilder:
	assert(0.0 < value)
	_generator_init.power = value
	return self

# アニメーション期間を設定します
func set_duration(value: float) -> StopMotionBuilder:
	assert(0.0 <= value)
	_generator_init.duration = value
	return self

# この距離を下回ると停止します
func set_rest_delta(value: float) -> StopMotionBuilder:
	assert(0.0 < value)
	_generator_init.rest_delta = value
	return self

# 初期速度を優先するよう設定します
func prefer_velocity() -> StopMotionBuilder:
	_generator_init.prefer = DecayMotionGeneratorInit.PREFER_VELOCITY
	return self

# 最終位置を優先するよう設定します
func prefer_position() -> StopMotionBuilder:
	_generator_init.prefer = DecayMotionGeneratorInit.PREFER_POSITION
	return self

# 開始までの遅延を設定します
func delay(value: float) -> StopMotionBuilder:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> StopMotionBuilder:
	_generator_init.delay = 0.0
	return self

# 初期位置を設定します
func from(position) -> StopMotionBuilder:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position) -> StopMotionBuilder:
	_generator_init.final_position = position
	return self

# 初期速度を設定します
func by(velocity) -> StopMotionBuilder:
	_generator_init.initial_velocity = velocity
	return self

#-------------------------------------------------------------------------------

var _generator_init: DecayMotionGeneratorInit

func _init(generator_init: DecayMotionGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
