class_name MovadoTweenGeneratorInit extends MovadoGeneratorInit

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

const DEFAULT_DURATION := 1.0
const DEFAULT_EASE_TYPE := Tween.EASE_IN_OUT
const DEFAULT_TRANS_TYPE := Tween.TRANS_LINEAR

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# アニメーション期間
var duration := DEFAULT_DURATION
# イージングタイプ
var ease_type := DEFAULT_EASE_TYPE
# トランジションタイプ
var trans_type := DEFAULT_TRANS_TYPE

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func init(
	state: MovadoState,
	last_generator: MovadoGenerator) -> MovadoGenerator:

	assert(state != null)
	assert(0.0 <= duration)

	MovadoStateHelper.set_initial_position(state, initial_position)
	MovadoStateHelper.set_final_position(state, final_position)
	MovadoStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	MovadoTweenGenerator.init(state)

	return MovadoTweenGenerator.new(
		duration,
		ease_type,
		trans_type)
