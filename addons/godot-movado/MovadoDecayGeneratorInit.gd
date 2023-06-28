class_name MovadoDecayGeneratorInit extends MovadoGeneratorInit

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
	state: MovadoState,
	last_generator: MovadoGenerator) -> MovadoGenerator:

	assert(state != null)
	assert(
		prefer == PREFER_VELOCITY or
		prefer == PREFER_POSITION)
	assert(0.0 < power)
	assert(0.0 < time_constant)
	assert(0.0 < rest_delta)

	MovadoStateHelper.set_initial_position(state, initial_position)
	MovadoStateHelper.set_final_position(state, final_position)
	MovadoStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	match prefer:
		PREFER_VELOCITY:
			MovadoDecayGenerator.init_prefer_velocity(
				state,
				power,
				time_constant,
				rest_delta)
		PREFER_POSITION:
			MovadoDecayGenerator.init_prefer_position(
				state,
				time_constant,
				rest_delta)

	return MovadoDecayGenerator.new(time_constant, rest_delta)
