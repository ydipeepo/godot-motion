 [English](https://github.com/ydipeepo/godot-motion/blob/main/README.md) | [日本語](https://github.com/ydipeepo/godot-motion/blob/main/README_jp.md) | 简体中文

<br />

[![MIT License](https://img.shields.io/badge/License-MIT-25B3A0?style=flat-square)](https://github.com/ydipeepo/godot-motion/blob/main/LICENSE.md)
[![Download](https://img.shields.io/badge/Download-1.0.0-DA1160?style=flat-square)](https://github.com/ydipeepo/godot-motion/releases/tag/stable)
[![@ydipeepo](https://img.shields.io/badge/@ydipeepo-1DA1F2?style=flat-square&logo=twitter&logoColor=white)](https://twitter.com/ydipeepo)

<br />

![Motion](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/header.png)

<br />

# Godot Motion

又一个用于 Godot 3 的 Tween。

<br />

* 易于使用流畅的写法
* 不要特殊逻辑
* 不要持续时间控制
* 基于运动学的自然插值
* 也具有与 Tween 相同的功能

<br />

---

<br />

## 安装

咱们仍处于测试阶段，因此仍然没有在 Godot AssetLib 上分发。

<br />

#### 检查演示项目

1. Git Clone 然后在 Godot 引擎中打开。
2. (选择 `demo/Demo_*.tscn` 作为主场景然后) 按 F5!

#### 安装这插件

1. Git clone 然后将 `addons/godot-motion` 复制到您的项目中。
2. 启用 `运动` 插件。
3. 写写代码。

<br />

## 如何动画?

有两种类的写法，根据情况会区分使用:

- [早期对象绑定写法](#早期对象绑定写法)
- [早期配置写法](#早期配置写法)

<br />

#### 早期对象绑定写法

这是一种写法，它决定了在早期绑定啥对象，然后随后配置动画。这是最常用的写法。

```GDScript
# 在这写法，弹簧动画开始于:
# - Motion.with()
# - Motion.with_method()
# - Motion.with_method_deferred()
Motion.with($Who, "what_property").to(100.0)

# Tween 风动画开始于:
# - Motion.ease()
# - Motion.ease_method()
# - Motion.ease_method_deferred()
Motion.ease($Who, "what_property").cubic().out().to(100.0)

# 这些返回值是一次性的。
# 它不能存储在变量中。
```

#### 早期配置写法

这是一种不太常用的写法，您先进行动画的配置，最后决定绑定啥对象将动画的。

```GDScript
# 可以从名为 "Motion.context.create_*()" 的方法创建每个生成器，
# 并且可以存储在变量中。
var my_spring := Motion.context.create_spring()
my_spring.start($Who, "what_property", null, 100.0)

# 与刚写的 "Motion.ease()" 的相同效果...
var my_tween := Motion.context.create_tween()
my_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
my_tween.start($Who, "what_property", null, 100.0)
```

<br />

## 如何配置动画?

此插件支持 3 种类的动画:

- [Tween 风动画](#tween-风动画)
- [弹簧动画](#弹簧动画)
- [衰减动画](#衰减动画)

每个都有不同的可配置的参数。

<br />

#### Tween 风动画

经常被称为 Tween，大家最熟悉的动画。这与 Tween 节点相同，但缺点是它没有速度信息。

* [Tween 风动画 (早期对象绑定写法) 配置方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/EaseMotionExpression.gd)
* [Tween 风动画 (早期配置写法) 配置方法](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/TweenMotionBuilder.gd) 和 [对象绑定方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### 弹簧动画

运动学基于弹簧动画。此动画类型将是此插件中使用最多的动画类。它具有速度，即使在动画中间也可以平滑连接。

* [弹簧动画 (早期对象绑定写法) 配置方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/WithMotionExpression.gd)
* [弹簧动画 (早期配置写法) 配置方法](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/SpringMotionBuilder.gd) 和 [对象绑定方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### 衰减动画

指数衰减动画。这有点特别，它从那个点的速度开始逐渐减速。

* [衰减动画 (早期对象绑定写法) 配置方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/StopMotionExpression.gd)
* [衰减动画 (早期配置写法) 配置方法](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/DecayMotionBuilder.gd) 和 [对象绑定方法一览](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

<br />

---

<br />

![欢迎贡献!](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/footer.png)

## 贡献

我们非常欢迎提供 bug 的修复、文档翻译，和任何其他改进! 谢谢!
