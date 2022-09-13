class_name MotionDelayedPosition

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 位置を取得します
func get_value():
	return _target.get_indexed(_target_property)

#-------------------------------------------------------------------------------

var _target: Node
var _target_property: NodePath

func _init(
	target: Node,
	target_property: NodePath) -> void:

	_target = target
	_target_property = target_property
