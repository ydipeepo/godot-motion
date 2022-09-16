extends Control

const _NUM_ICONS := 100

var _builders := []

func _ready():
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_STANDARD))
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_GENTLE))
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_WOBBLY))
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_STIFF))
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_SLOW))
	_builders.append(Motion.context.create_spring(MotionContext.SPRING_MOLASSES))

	var texture := load("res://editor/icon.png")
	for i in _NUM_ICONS:
		var sprite := Sprite.new()
		sprite.position = rect_size / 2.0
		sprite.texture = texture
		add_child(sprite)

func _on_Shuffle_pressed():
	for index in get_child_count():
		var sprite := get_child(index) as Sprite
		if not sprite:
			continue
		var builder: MotionBuilder = _builders[randi() % len(_builders)]
		builder.start(
			sprite,
			"position",
			null,
			Vector2(randf(), randf()) * rect_size)
