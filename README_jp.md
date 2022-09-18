[English](https://github.com/ydipeepo/godot-motion/blob/main/README.md) | 日本語 | [简体中文](https://github.com/ydipeepo/godot-motion/blob/main/README_zh.md)

<br />

[![MIT License](https://img.shields.io/badge/License-MIT-25B3A0?style=flat-square)](https://github.com/ydipeepo/godot-motion/blob/main/LICENSE.md)
[![Download](https://img.shields.io/badge/Download-1.0.0-DA1160?style=flat-square)](https://github.com/ydipeepo/godot-motion/releases/tag/stable)
[![@ydipeepo](https://img.shields.io/badge/@ydipeepo-1DA1F2?style=flat-square&logo=twitter&logoColor=white)](https://twitter.com/ydipeepo)

<br />

![Motion](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/header.png)

<br />

# Godot Motion

Godot 3 のためのもう一つの Tween。

<br />

* 流暢な構文で使いやすい
* アドホックロジックが要りません
* 期間の制御が要りません
* 物理ベースの自然な補間
* Tween と同じ機能も備えています

<br />

---

<br />

## 準備

まだテスト段階のため、Godot AssetLib では配信されていません。

* 申請中

<br />

#### デモを確認したい

1. このリポジトリをクローンして Godot Engine で開きます
2. (`demo/Demo_*.tscn` のうちどれか一つをメインシーンに設定して、) F5!

#### アドオンを導入したい

1. `addons/godot-motion` ディレクトリを丸ごとプロジェクトに複製します
2. `Motion` アドオンを有効にします
3. 書く。

<br />

## どうやってアニメーションさせるの？

好みや使い方に応じて二つの書き方があり、混在させることもできます:

- [早期バインディング](#早期バインディング)
- [早期構成](#早期構成)

<br />

#### 早期バインディング

これは最初の段階で何をアニメーションするかを決めておき、その後に
どのようなアニメーションにするか細かい部分を構成する書き方です。
最も使われる書き方です。

```GDScript
# バネアニメーションは以下のバインダメソッドから書き始めます:
# - Motion.with()
# - Motion.with_method()
# - Motion.with_method_deferred()
Motion.with($Who, "what_property").to(100.0)

# Tween アニメーションは以下のバインダメソッドから書き始めます:
# - Motion.ease()
# - Motion.ease_method()
# - Motion.ease_method_deferred()
Motion.ease($Who, "what_property").cubic().out().to(100.0)

# これらバインダメソッドの戻り値は変数などへ保存してはいけません。
# 使い捨てです。
```

#### 早期構成

これはあまり一般的ではない書き方で、最初の段階でどのようなアニメーションにするか細かい部分を
構成しておき、アニメーションを開始するタイミングで何をアニメーションするか決める書き方です。

```GDScript
# ビルダは `Motion.context.create_*()` というメソッドから作成することができ、
# 変数などへ保存しておくことができます。
var my_spring := Motion.context.create_spring()
my_spring.start($Who, "what_property", null, 100.0)

# 早期構成で書いた、`Motion.ease()` の例と同じ効果のアニメーション。
var my_tween := Motion.context.create_tween()
my_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
my_tween.start($Who, "what_property", null, 100.0)
```

<br />

## どうやってアニメーションを調整するの？

このアドオンでは 3 種類のアニメーションに対応しています:

- [Tween 風](#tween-風)
- [バネ](#バネ)
- [減衰](#減衰)

それぞれ異なる構成可能なパラメタがあります。

<br />

#### Tween 風

Tween と呼ばれることが多く、最も身近な補間アニメーションセットです。これは Tween ノードと同じですが、速度を持たないという欠点があります。

* [Tween 風、早期バインディングにおける構成メソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/EaseMotionExpression.gd)
* [Tween 風、早期構成における構成メソッド](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/TweenMotionBuilder.gd) と
[バインディングメソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### バネ

物理ベースのバネアニメーションです。このアニメーションは恐らくこのアドオンで最も使用されます。速度があり、アニメーションの途中であっても滑らかに次のアニメーションへ繋げることができます。

* [バネ、早期バインディングにおける構成メソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/WithMotionExpression.gd)
* [バネ、早期構成における構成メソッド](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/SpringMotionBuilder.gd) と [バインディングメソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)

#### 減衰

指数関数的な減衰アニメーションです。これは少し特殊で、その時点の速度を元に、徐々に減速していくアニメーションです。

* [減衰、早期バインディングにおける構成メソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/expression/StopMotionExpression.gd)
* [減衰、早期構成における構成メソッド](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/DecayMotionBuilder.gd) と [バインディングメソッドの一覧](https://github.com/ydipeepo/godot-motion/blob/main/addons/godot-motion/builder/MotionBuilder.gd)
<br />

---

<br />

![バグが減らない](https://raw.githubusercontent.com/ydipeepo/godot-motion/main/footer.png)

## バグの報告や要望など

バグの修正や報告、ドキュメント翻訳、およびその他の改善など歓迎いたします。

