<br />

<strong>This repo was no longer maintained. IDK it still works now or not, but feel free to use it if you need.</strong>

<br />

---

English | [日本語](https://github.com/ydipeepo/godot-motion/blob/main/README_jp.md) | [简体中文](https://github.com/ydipeepo/godot-motion/blob/main/README_zh.md)

<br />

[![MIT License](https://img.shields.io/badge/License-MIT-25B3A0?style=flat-square)](https://github.com/ydipeepo/godot-motion/blob/main/LICENSE.md)
[![Download](https://img.shields.io/badge/Download-1.0.0-DA1160?style=flat-square)](https://github.com/ydipeepo/godot-motion/releases/tag/stable)
[![@ydipeepo](https://img.shields.io/badge/@ydipeepo-1DA1F2?style=flat-square&logo=twitter&logoColor=white)](https://twitter.com/ydipeepo)

<br />

![Motion](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/header.png)

<br />

# Godot Motion

Yet another Tween for for Godot 3 / 4.

<br />

* Easy as fluent syntax to use
* No need adhoc logics
* No need duration control
* Kinematics-based natural interpolation
* Also has the same features as Tween

<br />

---

<br />

## How do I use it?

We are still in the testing phase, so still not distributing at Godot AssetLib.

<br />

#### Checking demos

1. Git clone then open in Godot Engine.
2. (Select `demo/Demo_*.tscn` as Main Scene then) F5! (for Godot 3.*)

#### Add-on installation

1. Git clone then copy `addons/godot-motion` or `addons/godot-movado` (for Godot 4) to your project.
2. Activate `Motion` addon.
3. Code!

<br />

## How do I animate object?

There are 2 types of coding style:

- [Early Binding Style](#early-binding-style-ebs)
- [Early Configuration Style](#early-configuration-style-ecs)

<br />

#### Early Binding Style (EBS)

This is a way of writing that decides what to animate early on,
then subsequently configures and attaches the animation.
It is the style that will be used most.

```GDScript
# Spring animation starts with:
# - Motion.with()
# - Motion.with_method()
# - Motion.with_method_deferred()
Motion.with($Who, "what_property").to(100.0)

# Tween-like animation starts with:
# - Motion.ease()
# - Motion.ease_method()
# - Motion.ease_method_deferred()
Motion.ease($Who, "what_property").cubic().out().to(100.0)

# These return values of the EBS are disposable.
# It cannot be stored in a variable!
```

#### Early Configuration Style (ECS)

This is a less commonly used style where you configure things first and
then use that configuration to attach the animation to the target.

```GDScript
# Each builder can be created from methods called '.create_*()',
# and it can be stored in a variable.
var my_spring := Motion.context.create_spring()
my_spring.start($Who, "what_property", null, 100.0)

# Same effect as before Motion.ease() for $Who's 'what_property'...
var my_tween := Motion.context.create_tween()
my_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
my_tween.start($Who, "what_property", null, 100.0)
```

<br />

## How do I configure animation?

This addon supports 3 types of animations:

- [Tween-like](#tween-like)
- [Spring](#spring)
- [Decay](#decay)

Each has different configurable parameters.

<br />

#### Tween-like

Often called Tween everywhere, the most familiar animation. This is the same as Tween node,
but with the drawback that it has no velocity information.

* [Tween-like EBS configuration methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/EaseMotionExpression.gd)
* [Tween-like ECS configuration](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/TweenMotionBuilder.gd) & [bind methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### Spring

Kinematics based spring animation. This animation type will be the most used in/with this addon.
It has velocity and can be connected smoothly even in the middle of animations.

* [Spring EBS configuration methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/WithMotionExpression.gd)
* [Spring ECS configuration](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/SpringMotionBuilder.gd) & [bind methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### Decay

Exponential decay animation. This is a bit special, that gradually decelerates from the velocity at that point.

* [Decay EBS configuration methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/StopMotionExpression.gd)
* [Decay ECS configuration](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/DecayMotionBuilder.gd) & [bind methods](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

<br />

---

<br />

![More contribution is needed!](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/footer.png)

## Contributing

We are grateful to the community for contributing bug fixes, documentation, translations, and any other improvements!

