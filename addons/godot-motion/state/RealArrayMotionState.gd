class_name RealArrayMotionState extends MotionState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	var zero := PoolRealArray()
	zero.resize(get_element_count())
	for i in get_element_count():
		zero[i] = 0.0
	return zero

func get_one():
	var one := PoolRealArray()
	one.resize(get_element_count())
	for i in get_element_count():
		one[i] = 1.0
	return one

func get_element_count() -> int:
	return _element_count

func get_element_component_count() -> int:
	return _ELEMENT_SIZE

func set_initial_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	initial_position[dimension] = component

func get_initial_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return initial_position[dimension]

func set_final_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	final_position[dimension] = component

func get_final_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return final_position[dimension]

func set_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	position[dimension] = component

func get_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return position[dimension]

func set_initial_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	_initial_velocity[dimension] = component

func get_initial_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return _initial_velocity[dimension]

func set_velocity(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	_velocity[dimension] = component

func get_velocity(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return _velocity[dimension]

func set_rest(dimension: int, component: bool) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	_rest[dimension] = component

func get_rest(dimension: int) -> bool:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return _rest[dimension]

func validate() -> bool:
	if typeof(position) == TYPE_ARRAY:
		position = PoolRealArray(position)
	if typeof(initial_position) == TYPE_ARRAY:
		initial_position = PoolRealArray(initial_position)
	if typeof(final_position) == TYPE_ARRAY:
		final_position = PoolRealArray(final_position)
	return (
		typeof(position) == TYPE_REAL_ARRAY and
		typeof(initial_position) == TYPE_REAL_ARRAY and
		typeof(final_position) == TYPE_REAL_ARRAY and
		len(position) == _element_count and
		len(initial_position) == _element_count and
		len(final_position) == _element_count)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 1

var _velocity := PoolRealArray()
var _initial_velocity := PoolRealArray()
var _rest := []
var _element_count: int

func _init(element_count: int) -> void:
	assert(0 <= element_count)

	_element_count = element_count

	position = PoolColorArray()
	position.resize(_element_count)
	for dimension in _element_count:
		position[dimension] = Color(0.0, 0.0, 0.0, 0.0)

	var dimension := _element_count * _ELEMENT_SIZE
	_velocity.resize(dimension)
	_initial_velocity.resize(dimension)
	_rest.resize(dimension)
	for k in dimension:
		_velocity[k] = 0.0
		_initial_velocity[k] = 0.0
		_rest[k] = true
