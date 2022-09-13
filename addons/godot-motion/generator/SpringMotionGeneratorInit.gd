class_name SpringMotionGeneratorInit extends MotionGeneratorInit

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# ばねの剛性係数
var stiffness := 100.0
# ばねの減衰係数
var damping := 10.0
# 対象の質量
var mass := 1.0
# 静止距離
var rest_delta := 0.001
# 静止速度
var rest_speed := 0.001
# 過減衰とならないよう制限するかどうか
var limit_overdamping := false
# オーバーシュートしないよう制限するかどうか
var limit_overshooting := false

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func init(
	state: MotionState,
	last_generator: MotionGenerator) -> MotionGenerator:

	assert(state != null)
	assert(0.0 < stiffness)
	assert(0.0 <= damping)
	assert(0.0 < mass)
	assert(0.0 < rest_delta)
	assert(0.0 < rest_speed)

	MotionStateHelper.set_initial_position(state, initial_position)
	MotionStateHelper.set_final_position(state, final_position)
	MotionStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	SpringMotionGenerator.init(state, rest_delta, rest_speed)

	return SpringMotionGenerator.new(
		stiffness,
		damping,
		mass,
		rest_delta,
		rest_speed,
		limit_overdamping,
		limit_overshooting)
