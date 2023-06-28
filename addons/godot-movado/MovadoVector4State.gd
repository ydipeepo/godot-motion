class_name MovadoVector4State extends MovadoState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	return Vector4.ZERO

func get_one():
	return Vector4.ONE

func get_element_count() -> int:
	return 1

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(dimension: int, component: float) -> void:
	initial_position[dimension] = component

func get_initial_position(dimension: int) -> float:
	return initial_position[dimension]

func set_final_position(dimension: int, component: float) -> void:
	final_position[dimension] = component

func get_final_position(dimension: int) -> float:
	return final_position[dimension]

func set_position(dimension: int, component: float) -> void:
	position[dimension] = component

func get_position(dimension: int) -> float:
	return position[dimension]

func set_initial_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_initial_velocity[dimension] = component

func get_initial_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _initial_velocity[dimension]

func set_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_velocity[dimension] = component

func get_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _velocity[dimension]

func set_rest(dimension: int, component: bool) -> void:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_rest[dimension] = component

func get_rest(dimension: int) -> bool:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _rest[dimension]

func validate() -> bool:
	return (
		typeof(position) == TYPE_VECTOR4 and
		typeof(initial_position) == TYPE_VECTOR4 and
		typeof(final_position) == TYPE_VECTOR4)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 4

var _velocity := [0.0, 0.0, 0.0, 0.0]
var _initial_velocity := [0.0, 0.0, 0.0, 0.0]
var _rest := [true, true, true, true]

func _init() -> void:
	position = Vector4.ZERO
