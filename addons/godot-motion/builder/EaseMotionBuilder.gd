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

func in() -> EaseMotionBuilder:
	_generator_init.ease_type = Tween.EASE_IN
	return self

func out() -> EaseMotionBuilder:
	_generator_init.ease_type = Tween.EASE_OUT
	return self

func in_out() -> EaseMotionBuilder:
	_generator_init.ease_type = Tween.EASE_IN_OUT
	return self

func out_in() -> EaseMotionBuilder:
	_generator_init.ease_type = Tween.EASE_OUT_IN
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> EaseMotionBuilder:
	_generator_init.trans_type = trans_type
	return self

func linear() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_LINEAR
	return self

func quad() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_QUAD
	return self

func cubic() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_CUBIC
	return self

func quart() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_QUART
	return self

func quint() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_QUINT
	return self

func sine() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_SINE
	return self

func expo() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_EXPO
	return self

func circ() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_CIRC
	return self

func elastic() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_ELASTIC
	return self

func back() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_BACK
	return self

func bounce() -> EaseMotionBuilder:
	_generator_init.trans_type = Tween.TRANS_BOUNCE
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
