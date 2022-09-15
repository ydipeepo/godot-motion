class_name Vector3ArrayMotionState extends MotionState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	var zero := PoolVector3Array()
	zero.resize(get_element_count())
	for i in get_element_count():
		zero[i] = Vector3.ZERO
	return zero

func get_one():
	var one := PoolVector3Array()
	one.resize(get_element_count())
	for i in get_element_count():
		one[i] = Vector3.ONE
	return one

func get_element_count() -> int:
	return _element_count

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	match dimension % _ELEMENT_SIZE:
		0: initial_position[int(dimension / _ELEMENT_SIZE)].x = component
		1: initial_position[int(dimension / _ELEMENT_SIZE)].y = component
		2: initial_position[int(dimension / _ELEMENT_SIZE)].z = component

func get_initial_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	var component: float
	match dimension % _ELEMENT_SIZE:
		0: component = initial_position[int(dimension / _ELEMENT_SIZE)].x
		1: component = initial_position[int(dimension / _ELEMENT_SIZE)].y
		2: component = initial_position[int(dimension / _ELEMENT_SIZE)].z
	return component

func set_final_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	match dimension % _ELEMENT_SIZE:
		0: final_position[int(dimension / _ELEMENT_SIZE)].x = component
		1: final_position[int(dimension / _ELEMENT_SIZE)].y = component
		2: final_position[int(dimension / _ELEMENT_SIZE)].z = component

func get_final_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	var component: float
	match dimension % _ELEMENT_SIZE:
		0: component = final_position[int(dimension / _ELEMENT_SIZE)].x
		1: component = final_position[int(dimension / _ELEMENT_SIZE)].y
		2: component = final_position[int(dimension / _ELEMENT_SIZE)].z
	return component

func set_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	match dimension % _ELEMENT_SIZE:
		0: position[int(dimension / _ELEMENT_SIZE)].x = component
		1: position[int(dimension / _ELEMENT_SIZE)].y = component
		2: position[int(dimension / _ELEMENT_SIZE)].z = component

func get_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	var component: float
	match dimension % _ELEMENT_SIZE:
		0: component = position[int(dimension / _ELEMENT_SIZE)].x
		1: component = position[int(dimension / _ELEMENT_SIZE)].y
		2: component = position[int(dimension / _ELEMENT_SIZE)].z
	return component

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
		position = PoolVector3Array(position)
	if typeof(initial_position) == TYPE_ARRAY:
		initial_position = PoolVector3Array(initial_position)
	if typeof(final_position) == TYPE_ARRAY:
		final_position = PoolVector3Array(final_position)
	return (
		typeof(position) == TYPE_VECTOR3_ARRAY and
		typeof(initial_position) == TYPE_VECTOR3_ARRAY and
		typeof(final_position) == TYPE_VECTOR3_ARRAY and
		len(position) == _element_count and
		len(initial_position) == _element_count and
		len(final_position) == _element_count)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 3

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
