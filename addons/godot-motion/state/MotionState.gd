class_name MotionState

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# 現在位置
var position
# 開始位置
var initial_position
# 終了位置
var final_position

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# すべての要素が 0 の値を返します
func get_zero():
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return null

# すべての要素が 1 の値を返します
func get_one():
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return null

# 要素数を返します
func get_element_count() -> int:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0

# 要素あたりの成分数を返します
func get_element_size() -> int:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0

# 開始位置の指定した成分を設定します
func set_initial_position(
	dimension: int,
	component: float) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 開始位置の指定した成分を取得します
func get_initial_position(dimension: int) -> float:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0.0

# 終了位置の指定した成分を設定します
func set_final_position(
	dimension: int,
	component: float) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 終了位置の指定した成分を取得します
func get_final_position(dimension: int) -> float:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0.0

# 現在位置の指定した成分を設定します
func set_position(
	dimension: int,
	component: float) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 現在位置の指定した成分を取得します
func get_position(dimension: int) -> float:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0.0

# 開始速度の指定した成分を設定します
func set_initial_velocity(
	dimension: int,
	component: float) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 開始速度の指定した成分を取得します
func get_initial_velocity(dimension: int) -> float:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0.0

# 速度の指定した成分を設定します
func set_velocity(
	dimension: int,
	component: float) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 速度の指定した成分を取得します
func get_velocity(dimension: int) -> float:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return 0.0

# 指定した次元が静止しているかを設定します
func set_rest(
	dimension: int,
	component: bool) -> void:

	#
	# 継承先で実装する必要があります
	#

	assert(false)

# 指定した次元が静止しているかを取得します
func get_rest(dimension: int) -> bool:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return false

# 各値を正規化しそれが妥当かどうかを調べます
func validate() -> bool:
	#
	# 継承先で実装する必要があります
	#

	assert(false)
	return false

# warning-ignore-all: UNUSED_ARGUMENT
