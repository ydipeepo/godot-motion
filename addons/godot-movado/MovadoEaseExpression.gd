class_name MovadoEaseExpression

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# アニメーション期間を設定します
func set_duration(value: float) -> MovadoEaseExpression:
	assert(0.0 <= value)
	_generator_init.duration = value
	return self

# イージングタイプを設定します
func set_ease(ease_type: int) -> MovadoEaseExpression:
	_generator_init.ease_type = ease_type
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> MovadoEaseExpression:
	_generator_init.trans_type = trans_type
	return self

## イージングタイプに Tween.EASE_IN を設定します
#func in() -> MovadoEaseExpression:
#	return set_ease(Tween.EASE_IN)

## イージングタイプに Tween.EASE_OUT を設定します
#func out() -> MovadoEaseExpression:
#	return set_ease(Tween.EASE_OUT)

## イージングタイプに Tween.EASE_IN_OUT を設定します
#func in_out() -> MovadoEaseExpression:
#	return set_ease(Tween.EASE_IN_OUT)

## イージングタイプに Tween.EASE_OUT_IN を設定します
#func out_in() -> MovadoEaseExpression:
#	return set_ease(Tween.EASE_OUT_IN)

# トランジションタイプに Tween.TRANS_LINEAR を設定します
func linear() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_LINEAR)

# トランジションタイプに Tween.TRANS_QUAD を設定します
func quad() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_QUAD)

# トランジションタイプに Tween.TRANS_CUBIC を設定します
func cubic() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_CUBIC)

# トランジションタイプに Tween.TRANS_QUART を設定します
func quart() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_QUART)

# トランジションタイプに Tween.TRANS_QUINT を設定します
func quint() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_QUINT)

# トランジションタイプに Tween.TRANS_SINE を設定します
func sine() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_SINE)

# トランジションタイプに Tween.TRANS_EXPO を設定します
func expo() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_EXPO)

# トランジションタイプに Tween.TRANS_CIRC を設定します
func circ() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_CIRC)

# トランジションタイプに Tween.TRANS_ELASTIC を設定します
func elastic() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_ELASTIC)

# トランジションタイプに Tween.TRANS_BACK を設定します
func back() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_BACK)

# トランジションタイプに Tween.TRANS_BOUNCE を設定します
func bounce() -> MovadoEaseExpression:
	return set_trans(Tween.TRANS_BOUNCE)

# 開始までの遅延を設定します
func delay(value: float) -> MovadoEaseExpression:
	assert(0.0 <= value)
	_generator_init.delay = value
	return self

# 開始までの遅延を解除します
func undelay() -> MovadoEaseExpression:
	_generator_init.delay = 0.0
	return self

# 初期位置を設定します
func from(position) -> MovadoEaseExpression:
	_generator_init.initial_position = position
	return self

# 終了位置を設定します
func to(position) -> MovadoEaseExpression:
	_generator_init.final_position = position
	return self

#-------------------------------------------------------------------------------

var _generator_init: MovadoTweenGeneratorInit

func _init(generator_init: MovadoTweenGeneratorInit) -> void:
	assert(generator_init != null)

	_generator_init = generator_init
