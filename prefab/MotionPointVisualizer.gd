extends Control

export(Color) var axis_x_color := Color.red
export(Color) var axis_y_color := Color.blue
export(Color) var point_color := Color.white
export(Color) var point_trail_color := Color(1.0, 1.0, 1.0, 0.25)
export(Color) var point_axis_x_background := Color.red
export(Color) var point_axis_x_foreground := Color.white
export(Color) var point_axis_y_background := Color.blue
export(Color) var point_axis_y_foreground := Color.white
export(Color) var velocity_x_color := Color.magenta
export(Color) var velocity_y_color := Color.cyan

var point: Vector2 setget _set_point, _get_point
var velocity: Vector2 setget _set_velocity, _get_velocity
var center_offset: Vector2 setget , _get_center_offset

#-------------------------------------------------------------------------------

func _set_point(value: Vector2) -> void:
	if _point != value:
		_point = value
		_point_list.push_back(value)
		while len(_point_list) > _POINT_LIST_MAX:
			_point_list.pop_front()
		_update_point()

func _get_point() -> Vector2:
	return _point

func _set_velocity(value: Vector2) -> void:
	$VelocityX.points[1].x = value.x
	$VelocityY.points[1].y = value.y

func _get_velocity() -> Vector2:
	return Vector2(
		$VelocityX.points[1].x,
		$VelocityY.points[1].y)

func _get_center_offset() -> Vector2:
	return _center_offset

const _POINT_LIST_MAX := 512

var _point := Vector2.ZERO
var _point_list := []
var _velocity := Vector2.ZERO
var _center_offset := Vector2.ZERO

func _ready() -> void:
	$AxisX.default_color = axis_x_color
	$AxisY.default_color = axis_y_color
	$Point.modulate = point_color
	$PointTrail.points = _point_list
	$PointTrail.modulate = point_trail_color
	$PointAxisX.default_color = point_axis_x_background
	$PointAxisXRect.color = point_axis_x_background
	$PointAxisXLabel.modulate = point_axis_x_foreground
	$PointAxisY.default_color = point_axis_y_background
	$PointAxisYRect.color = point_axis_y_background
	$PointAxisYLabel.modulate = point_axis_y_foreground
	$VelocityX.default_color = velocity_x_color
	$VelocityY.default_color = velocity_y_color

	_on_resized()

func _update_point() -> void:
	$Point.position = _center_offset + _point
	$PointTrail.points = _point_list
	$PointAxisX.position.y = _center_offset.y + _point.y
	$PointAxisXRect.rect_position.y = _center_offset.y + _point.y - $PointAxisXRect.rect_size.y * 0.5
	$PointAxisXLabel.rect_position.y = _center_offset.y + _point.y - $PointAxisXLabel.rect_size.y * 0.5
	$PointAxisXLabel.text = "%.1f" % _point.y
	$PointAxisY.position.x = _center_offset.x + _point.x
	$PointAxisYRect.rect_position.x = _center_offset.x + _point.x - $PointAxisYRect.rect_size.x * 0.5
	$PointAxisYLabel.rect_position.x = _center_offset.x + _point.x - $PointAxisYLabel.rect_size.x * 0.5
	$PointAxisYLabel.text = "%.1f" % _point.x
	$VelocityX.position = _center_offset + _point
	$VelocityY.position = _center_offset + _point

func _on_resized() -> void:
	_center_offset = rect_size * 0.5

	$AxisX.points[1] = Vector2(rect_size.x, 0.0)
	$AxisX.position.y = _center_offset.y
	$AxisY.points[1] = Vector2(0.0, rect_size.y)
	$AxisY.position.x = _center_offset.x
	$PointTrail.position = _center_offset
	$PointAxisX.points[1] = Vector2(rect_size.x - $PointAxisXRect.rect_size.x, 0.0)
	$PointAxisXRect.rect_position.x = rect_size.x - $PointAxisXRect.rect_size.x
	$PointAxisXLabel.rect_position.x = rect_size.x - $PointAxisXLabel.rect_size.x
	$PointAxisY.points[1] = Vector2(0.0, rect_size.y - $PointAxisYRect.rect_size.y)
	$PointAxisYRect.rect_position.y = rect_size.y - $PointAxisYRect.rect_size.y
	$PointAxisYLabel.rect_position.y = rect_size.y - $PointAxisYLabel.rect_size.y

	_update_point()
