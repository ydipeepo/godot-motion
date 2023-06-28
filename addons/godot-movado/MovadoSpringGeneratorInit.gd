class_name MovadoSpringGeneratorInit extends MovadoGeneratorInit

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

const DEFAULT_STIFFNESS := 100.0
const DEFAULT_DAMPING := 10.0
const DEFAULT_MASS := 1.0
const DEFAULT_REST_DELTA := 0.001
const DEFAULT_REST_SPEED := 0.001
const DEFAULT_LIMIT_OVERDAMPING := false
const DEFAULT_LIMIT_OVERSHOOTING := false

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# ばねの剛性係数
var stiffness := DEFAULT_STIFFNESS
# ばねの減衰係数
var damping := DEFAULT_DAMPING
# 対象の質量
var mass := DEFAULT_MASS
# 静止距離
var rest_delta := DEFAULT_REST_DELTA
# 静止速度
var rest_speed := DEFAULT_REST_SPEED
# 過減衰とならないよう制限するかどうか
var limit_overdamping := DEFAULT_LIMIT_OVERDAMPING
# オーバーシュートしないよう制限するかどうか
var limit_overshooting := DEFAULT_LIMIT_OVERSHOOTING

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func init(
	state: MovadoState,
	last_generator: MovadoGenerator) -> MovadoGenerator:

	assert(state != null)
	assert(0.0 < stiffness)
	assert(0.0 <= damping)
	assert(0.0 < mass)
	assert(0.0 < rest_delta)
	assert(0.0 < rest_speed)

	MovadoStateHelper.set_initial_position(state, initial_position)
	MovadoStateHelper.set_final_position(state, final_position)
	MovadoStateHelper.set_initial_velocity(state, initial_velocity)

	var state_valid := state.validate()
	assert(state_valid)

	MovadoSpringGenerator.init(state, rest_delta, rest_speed)

	return MovadoSpringGenerator.new(
		stiffness,
		damping,
		mass,
		rest_delta,
		rest_speed,
		limit_overdamping,
		limit_overshooting)
