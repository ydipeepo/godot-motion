class_name ColorMotionState extends MotionState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	return Color(0.0, 0.0, 0.0, 0.0)

func get_one():
	return Color.white

func get_element_count() -> int:
	return 1

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(
	dimension: int,
	component: float) -> void:

	match dimension:
		0: initial_position.r = component
		1: initial_position.g = component
		2: initial_position.b = component
		3: initial_position.a = component
		_: assert(false)

func get_initial_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = initial_position.r
		1: component = initial_position.g
		2: component = initial_position.b
		3: component = initial_position.a
		_: assert(false)
	return component

func set_final_position(
	dimension: int,
	component: float) -> void:

	match dimension:
		0: final_position.r = component
		1: final_position.g = component
		2: final_position.b = component
		3: final_position.a = component
		_: assert(false)

func get_final_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = final_position.r
		1: component = final_position.g
		2: component = final_position.b
		3: component = final_position.a
		_: assert(false)
	return component

func set_position(
	dimension: int,
	component: float) -> void:

	match dimension:
		0: position.r = component
		1: position.g = component
		2: position.b = component
		3: position.a = component
		_: assert(false)

func get_position(dimension: int) -> float:
	var component: float
	match dimension:
		0: component = position.r
		1: component = position.g
		2: component = position.b
		3: component = position.a
		_: assert(false)
	return component

func set_initial_velocity(
	dimension: int,
	component: float) -> void:

	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_initial_velocity[dimension] = component

func get_initial_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _initial_velocity[dimension]

func set_velocity(
	dimension: int,
	component: float) -> void:

	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_velocity[dimension] = component

func get_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _velocity[dimension]

func set_rest(
	dimension: int,
	component: bool) -> void:

	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	_rest[dimension] = component

func get_rest(dimension: int) -> bool:
	assert(0 <= dimension and dimension < _ELEMENT_SIZE)
	return _rest[dimension]

func validate() -> bool:
	return (
		typeof(position) == TYPE_COLOR and
		typeof(initial_position) == TYPE_COLOR and
		typeof(final_position) == TYPE_COLOR)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 4

var _velocity := PoolRealArray([0.0, 0.0, 0.0, 0.0])
var _initial_velocity := PoolRealArray([0.0, 0.0, 0.0, 0.0])
var _rest := [true, true, true, true]

func _init() -> void:
	position = Color(0.0, 0.0, 0.0, 0.0)
