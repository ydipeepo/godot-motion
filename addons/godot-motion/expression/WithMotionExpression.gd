class_name WithMotionExpression

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 剛性係数を設定します
func set_stiffness(value: float) -> WithMotionExpression:
	assert(0.0 < value)
	_generator_init.stiffness = value
	return self

# 減衰係数を設定します
func set_damping(value: float) -> WithMotionExpression:
	assert(0.0 <= value)
	_generator_init.damping = value
	return self

# (ばねの端にぶら下がっている) 物体の質量を設定します
func set_mass(value: float) -> WithMotionExpression:
	assert(0.0 < value)
	_generator_init.mass = value
	return self

# この速度を下回ると停止したとみなされる可能性があります。set_rest_delta() と両方の条件が揃うと停止します
func set_rest_speed(value: float) -> WithMotionExpression:
	assert(0.0 < value)
	_generator_init.rest_speed = value
	return self

# この距離を下回ると停止したとみなされる可能性があります。set_rest_speed() と両方の条件が揃うと停止します
func set_rest_delta(value: float) -> WithMotionExpression:
	assert(0.0 < value)
	_generator_init.rest_delta = value
	return self

# 過減衰とならないよう制限します
func limit_overdamping() -> WithMotionExpression:
	_generator_init.limit_overdamping = true
	return self

# limit_overdamping() で設定した制限を解除します
func unlimit_overdamping() -> WithMotionExpression:
	_generator_init.limit_overdamping = false
	return self

# 停止位置をオーバーシュートしないよう制限します
func limit_overshooting() -> WithMotionExpression:
	_generator_init.limit_overshooting = true
	return self

# limit_overshooting() で設定した制限を解除します
func unlimit_overshooting() -> WithMotionExpression:
	_generator_init.limit_overshooting = false
	return self

# 開始までの遅延を設定します
func delay(value: float) -> WithMotionExpression:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> WithMotionExpression:
	_generator_init.delay = 0.0
	return self

# 処理モードを設定します
func set_process_mode(value: int) -> WithMotionExpression:
	assert(
		value == MotionGeneratorInit.PROCESS_MODE_DEFAULT or
		value == MotionGeneratorInit.PROCESS_MODE_PHYSICS)
	_generator_init.process_mode = value
	return self

# 初期位置を設定します
func from(position) -> WithMotionExpression:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position) -> WithMotionExpression:
	_generator_init.final_position = position
	return self

# 初期速度を設定します
func by(velocity) -> WithMotionExpression:
	_generator_init.initial_velocity = velocity
	return self

#-------------------------------------------------------------------------------

var _generator_init: SpringMotionGeneratorInit

func _init(generator_init: SpringMotionGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
	.call_deferred("free")
