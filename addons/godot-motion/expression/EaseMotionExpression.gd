class_name EaseMotionExpression

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# アニメーション期間を設定します
func set_duration(value: float) -> EaseMotionExpression:
	assert(0.0 <= value)
	_generator_init.duration = value
	return self

# イージングタイプを設定します
func set_ease(ease_type: int) -> EaseMotionExpression:
	_generator_init.ease_type = ease_type
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> EaseMotionExpression:
	_generator_init.trans_type = trans_type
	return self

# イージングタイプに Tween.EASE_IN を設定します
func in() -> EaseMotionExpression:
	return set_ease(Tween.EASE_IN)

# イージングタイプに Tween.EASE_OUT を設定します
func out() -> EaseMotionExpression:
	return set_ease(Tween.EASE_OUT)

# イージングタイプに Tween.EASE_IN_OUT を設定します
func in_out() -> EaseMotionExpression:
	return set_ease(Tween.EASE_IN_OUT)

# イージングタイプに Tween.EASE_OUT_IN を設定します
func out_in() -> EaseMotionExpression:
	return set_ease(Tween.EASE_OUT_IN)

# トランジションタイプに Tween.TRANS_LINEAR を設定します
func linear() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_LINEAR)

# トランジションタイプに Tween.TRANS_QUAD を設定します
func quad() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_QUAD)

# トランジションタイプに Tween.TRANS_CUBIC を設定します
func cubic() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_CUBIC)

# トランジションタイプに Tween.TRANS_QUART を設定します
func quart() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_QUART)

# トランジションタイプに Tween.TRANS_QUINT を設定します
func quint() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_QUINT)

# トランジションタイプに Tween.TRANS_SINE を設定します
func sine() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_SINE)

# トランジションタイプに Tween.TRANS_EXPO を設定します
func expo() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_EXPO)

# トランジションタイプに Tween.TRANS_CIRC を設定します
func circ() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_CIRC)

# トランジションタイプに Tween.TRANS_ELASTIC を設定します
func elastic() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_ELASTIC)

# トランジションタイプに Tween.TRANS_BACK を設定します
func back() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_BACK)

# トランジションタイプに Tween.TRANS_BOUNCE を設定します
func bounce() -> EaseMotionExpression:
	return set_trans(Tween.TRANS_BOUNCE)

# 開始までの遅延を設定します
func delay(value: float) -> EaseMotionExpression:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> EaseMotionExpression:
	_generator_init.delay = 0.0
	return self

# 初期位置を設定します
func from(position) -> EaseMotionExpression:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position) -> EaseMotionExpression:
	_generator_init.final_position = position
	return self

#-------------------------------------------------------------------------------

var _generator_init: TweenMotionGeneratorInit

func _init(generator_init: TweenMotionGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
	.call_deferred("free")
