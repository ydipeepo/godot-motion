class_name Vector2MotionState extends MotionState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	return Vector2.ZERO

func get_one():
	return Vector2.ONE

func get_element_count() -> int:
	return 1

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(dimension: int, component: float) -> void:
	match dimension:
		0: initial_position.x = component
		1: initial_position.y = component
		_: assert(false)

func get_initial_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = initial_position.x
		1: component = initial_position.y
		_: assert(false)
	return component

func set_final_position(dimension: int, component: float) -> void:
	match dimension:
		0: final_position.x = component
		1: final_position.y = component
		_: assert(false)

func get_final_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = final_position.x
		1: component = final_position.y
		_: assert(false)
	return component

func set_position(dimension: int, component: float) -> void:
	match dimension:
		0: position.x = component
		1: position.y = component
		_: assert(false)

func get_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = position.x
		1: component = position.y
		_: assert(false)
	return component

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
		typeof(position) == TYPE_VECTOR2 and
		typeof(initial_position) == TYPE_VECTOR2 and
		typeof(final_position) == TYPE_VECTOR2)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 2

var _velocity := PoolRealArray([0.0, 0.0])
var _initial_velocity := PoolRealArray([0.0, 0.0])
var _rest := [true, true]

func _init() -> void:
	position = Vector2.ZERO
