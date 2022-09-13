class_name MotionGeneratorInit

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# 初期位置
var initial_position
# 最終位置
var final_position
# 初期速度
var initial_velocity
# 遅延
var delay := 0.0

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# ステートを t=0 の状態へ初期化しジェネレータを作成します
func init(
	state: MotionState,
	last_generator: MotionGenerator) -> MotionGenerator:

	#
	# 継承先で実装する必要があります。
	#

	assert(false)
	return null

# warning-ignore-all: UNUSED_ARGUMENT
