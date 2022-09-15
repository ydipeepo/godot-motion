class_name DecayMotionGeneratorInit extends MotionGeneratorInit

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

enum {
	# 開始速度から終了位置を決定する
	PREFER_VELOCITY,
	# 終了位置から開始速度を決定する
	PREFER_POSITION,
}

const DEFAULT_PREFER := PREFER_VELOCITY
const DEFAULT_POWER := 0.8
const DEFAULT_TIME_CONSTANT := 0.35
const DEFAULT_REST_DELTA := 0.001

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# 初期速度を優先するか最終位置を優先するか
var prefer := PREFER_VELOCITY
# 最終位置をどれくらい離すか
var power := DEFAULT_POWER
# 時間定数
var time_constant := DEFAULT_TIME_CONSTANT
# 静止距離
var rest_delta := DEFAULT_REST_DELTA

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func init(
	state: MotionState,
	last_generator: MotionGenerator) -> MotionGenerator:

	assert(state != null)
	assert(
		prefer == PREFER_VELOCITY or
		prefer == PREFER_POSITION)
	assert(0.0 < power)
	assert(0.0 < time_constant)
	assert(0.0 < rest_delta)

	MotionStateHelper.set_initial_position(state, initial_position)
	MotionStateHelper.set_final_position(state, final_position)
	MotionStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	match prefer:
		PREFER_VELOCITY:
			DecayMotionGenerator.init_prefer_velocity(
				state,
				power,
				time_constant,
				rest_delta)
		PREFER_POSITION:
			DecayMotionGenerator.init_prefer_position(
				state,
				time_constant,
				rest_delta)

	return DecayMotionGenerator.new(time_constant, rest_delta)
