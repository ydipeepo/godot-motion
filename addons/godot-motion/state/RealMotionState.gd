class_name RealMotionState extends MotionState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	return 0.0

func get_one():
	return 1.0

func get_element_count() -> int:
	return 1

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	initial_position = component

func get_initial_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return initial_position

func set_final_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	final_position = component

func get_final_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return final_position

func set_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	position = component

func get_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return position

func set_initial_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_initial_velocity = component

func get_initial_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _initial_velocity

func set_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_velocity = component

func get_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _velocity

func set_rest(dimension: int, component: bool) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_rest = component

func get_rest(dimension: int) -> bool:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _rest

func validate() -> bool:
	return (
		typeof(position) == TYPE_REAL and
		typeof(initial_position) == TYPE_REAL and
		typeof(final_position) == TYPE_REAL)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 1

var _velocity := 0.0
var _initial_velocity := 0.0
var _rest := true

func _init() -> void:
	position = 0.0
