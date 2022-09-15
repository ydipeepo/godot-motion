class_name TweenMotionGeneratorInit extends MotionGeneratorInit

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# アニメーション期間
var duration := 0.35
# イージングタイプ
var ease_type := Tween.EASE_IN_OUT
# トランジションタイプ
var trans_type := Tween.TRANS_LINEAR

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func init(
	state: MotionState,
	last_generator: MotionGenerator) -> MotionGenerator:

	assert(state != null)
	assert(0.0 <= duration)

	MotionStateHelper.set_initial_position(state, initial_position)
	MotionStateHelper.set_final_position(state, final_position)
	MotionStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	TweenMotionGenerator.init(state)

	return TweenMotionGenerator.new(
		duration,
		ease_type,
		trans_type)
