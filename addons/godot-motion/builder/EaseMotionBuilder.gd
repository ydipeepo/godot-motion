class_name EaseMotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# アニメーション期間を設定します
func set_duration(value: float) -> EaseMotionBuilder:
	assert(0.0 <= value)
	_generator_init.duration = value
	return self

# イージングタイプを設定します
func set_ease(ease_type: int) -> EaseMotionBuilder:
	_generator_init.ease_type = ease_type
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> EaseMotionBuilder:
	_generator_init.trans_type = trans_type
	return self

# 開始までの遅延を設定します
func delay(value: float) -> EaseMotionBuilder:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> EaseMotionBuilder:
	_generator_init.delay = 0.0
	return self

# 初期位置を設定します
func from(position) -> EaseMotionBuilder:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position) -> EaseMotionBuilder:
	_generator_init.final_position = position
	return self

#-------------------------------------------------------------------------------

var _generator_init: TweenMotionGeneratorInit

func _init(generator_init: TweenMotionGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
