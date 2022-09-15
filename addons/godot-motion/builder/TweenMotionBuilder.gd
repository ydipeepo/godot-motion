class_name TweenMotionBuilder extends MotionBuilder

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

func get_context():
	return _context

func build_generator_init(
	initial_position,
	final_position,
	initial_velocity) -> MotionGeneratorInit:

	var generator_init := TweenMotionGeneratorInit.new()
	generator_init.duration = _duration
	generator_init.ease_type = _ease_type
	generator_init.trans_type = _trans_type
	generator_init.initial_position = initial_position
	generator_init.final_position = final_position
	generator_init.initial_velocity = initial_velocity
	generator_init.delay = _delay
	return generator_init

# アニメーション期間を設定します
func set_duration(value: float) -> TweenMotionBuilder:
	assert(0.0 <= value)
	_duration = value
	return self

# イージングタイプを設定します
func set_ease(ease_type: int) -> TweenMotionBuilder:
	_ease_type = ease_type
	return self

# トランジションタイプを設定します
func set_trans(trans_type: int) -> TweenMotionBuilder:
	_trans_type = trans_type
	return self

# 開始までの遅延を設定します
func set_delay(value: float) -> TweenMotionBuilder:
	assert(0.0 <= value)
	_delay = value
	return self

#-------------------------------------------------------------------------------

var _context

var _duration := TweenMotionGeneratorInit.DEFAULT_DURATION
var _ease_type := TweenMotionGeneratorInit.DEFAULT_EASE_TYPE
var _trans_type := TweenMotionGeneratorInit.DEFAULT_TRANS_TYPE
var _delay := 0.0

func _init(context) -> void:
	assert(context != null)

	_context = context
