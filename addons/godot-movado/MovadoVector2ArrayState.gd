class_name MovadoVector2ArrayState extends MovadoState

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_zero():
	var array := PackedVector2Array()
	array.resize(get_element_count())
	array.fill(Vector2.ZERO)
	return array

func get_one():
	var array := PackedVector2Array()
	array.resize(get_element_count())
	array.fill(Vector2.ONE)
	return array

func get_element_count() -> int:
	return _element_count

func get_element_size() -> int:
	return _ELEMENT_SIZE

func set_initial_position(
	dimension: int,
	component: float) -> void:

	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	initial_position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE] = component

func get_initial_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return initial_position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE]

func set_final_position(
	dimension: int,
	component: float) -> void:

	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	final_position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE] = component

func get_final_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return final_position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE]

func set_position(dimension: int, component: float) -> void:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE] = component

func get_position(dimension: int) -> float:
	assert(0 <= dimension and dimension < _element_count * _ELEMENT_SIZE)
	return position[int(dimension / _ELEMENT_SIZE)][dimension % _ELEMENT_SIZE]

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
		position = PackedVector2Array(position)
	if typeof(initial_position) == TYPE_ARRAY:
		initial_position = PackedVector2Array(initial_position)
	if typeof(final_position) == TYPE_ARRAY:
		final_position = PackedVector2Array(final_position)
	return (
		typeof(position) == TYPE_PACKED_VECTOR2_ARRAY and
		typeof(initial_position) == TYPE_PACKED_VECTOR2_ARRAY and
		typeof(final_position) == TYPE_PACKED_VECTOR2_ARRAY and
		len(position) == _element_count and
		len(initial_position) == _element_count and
		len(final_position) == _element_count)

#-------------------------------------------------------------------------------

const _ELEMENT_SIZE := 2

var _velocity := PackedFloat32Array()
var _initial_velocity := PackedFloat32Array()
var _rest := []
var _element_count: int

func _init(element_count: int) -> void:
	assert(0 <= element_count)

	_element_count = element_count

	position = PackedVector2Array()
	position.resize(_element_count)
	position.fill(Vector2.ZERO)

	var dimension := _element_count * _ELEMENT_SIZE
	_velocity.resize(dimension)
	_velocity.fill(0.0)
	_initial_velocity.resize(dimension)
	_initial_velocity.fill(0.0)
	_rest.resize(dimension)
	_rest.fill(true)
