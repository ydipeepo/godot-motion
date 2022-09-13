# Godot Motion

Godot 3 用のアニメーションアドオン。

```GDScript
func _on_Button_pressed() -> void:
	Motion \
		.with($Button, "rect_scale") \
		.by(Vector2(randf() * 0.5 + 0.5, randf() * 0.5 + 0.5) * 1000.0) \
		.to(Vector2.ONE)
```



![Godot Motion](D:\Desktop\godot-motion.gif)



#### Tween と比較して...

以下の特徴があります。

* 個々のアニメーションを接続する為のアドホックな処理を書かなくてよくなる
  * アニメーション完了までの期間を考える必要がなくなる
  * 完了を待たず次のアニメーションを開始できる
  * 速度の情報を持つため滑らかに次のアニメーションへ接続できる
* 同じくらいには簡単に使える
  * (詰めれば) 一行で開始しそのまま丸投げできる
  * 複雑なこともできる

* たぶん軽い



## 準備

デモプロジェクトを含んでいるため確認する場合はそのまま実行します。
導入する場合は以下のステップに従ってください:

1. `res://addons/godot-motion` ディレクトリを丸ごとあなたのプロジェクトディレクトリにコピーします。
2. `Motion` アドオンを有効化します。
3. 書く。



#### 消すには...

`Motion` アドオンを無効化し、`godot-motion` ディレクトリをあなたのプロジェクトから削除します。



## 使いかた

アドオンを有効化すると、`Motion` というシングルトンが追加されます。
すべての操作はこのシングルトンを起点に行います。



----



![.with() and .to()](D:\Desktop\with_to.gif)



#### バネのようにアニメーションさせたい

`Target` ノードの `target_property` プロパティを現在値から 100 まで変化させる場合:

```GDScript
Motion \
	.with($Target, "target_property") \
	.to(100.0)
```

`Target` ノードの `target_method` メソッドに 0 から 100 まで変化させた値を渡したい場合:

```GDScript
Motion \
	.with_method($Target, "target_method") \
	.from(0.0) \
	.to(100.0)
```

`Target` ノードの `target_method` メソッドに対して call_deferred により  0 から 100 まで変化させた値を渡したい場合:

```GDScript
Motion \
	.with_method_deferred($Target, "target_method") \
	.from(0.0) \
	.to(100.0)
```



----



![Stop](D:\Desktop\stop.gif)



#### ゆっくり停止させるようにアニメーションさせたい

`Target` ノードの `target_property` プロパティを現在のアニメーションからゆっくり停止させる場合:

```GDScript
Motion.stop($Target, "target_property")
```

他にも `.stop_method()`、`.stop_method_deferred()` というメソッドがありますが `.stop()` と似たようなものなので省略します。



----



#### バネを構成したい

剛性係数、減衰係数、質量の 3 つのパラメタからバネの動きを変更できます。

```GDScript
Motion \
	.with($Target, "target_property") \
	.set_stiffness(300.0) \ # 剛性係数
	.set_damping(5.0) \     # 減衰係数
	.set_mass(5.0) \        # 質量
	.to(100.0)
```

また、`.with*()` の第三引数にプリセットを指定できます。

| プリセット      | 剛性係数 | 減衰係数 |
| --------------- | -------- | -------- |
| SPRING_DEFAULT  | 170.0    | 26.0     |
| SPRING_GENTLE   | 120.0    | 14.0     |
| SPRING_WOBBLY   | 210.0    | 20.0     |
| SPRING_STIFF    | 210.0    | 60.0     |
| SPRING_SLOW     | 280.0    | 60.0     |
| SPRING_MOLASSES | 280.0    | 120.0    |

以下のように指定します:

```GDScript
Motion.with($Target, "target_property", Motion.SPRING_DEFAULT)
```



----



#### 最終位置だけではなく、初期速度や初期位置を与えたい

初期位置、初期速度を与えることもできます。

```GDScript
Motion \
	.with($Target, "target_property") \
	.from(0.0) \  # 初期位置
	.by(1000.0) \ # 初期速度 (1000/s)
	.to(100.0)    # 最終位置
```



----



#### 静止速度・距離を構成したい

静止速度、静止距離の 2 つのパラメタからバネが静止状態になる条件を変更できます。

```GDScript
Motion \
	.with($Target, "target_property") \
	.set_rest_speed(1.0) \ # 静止速度
	.set_rest_delta(1.0) \ # 静止距離
	.to(100.0)
```

この 2 つの条件が満たされると最終位置が設定され、速度は 0 になり、バネは静止状態に移行します。



----



#### 過減衰を制限したい

バネの構成により過減衰となっている場合、臨界減衰になるよう自動的に制限することができます。

```GDScript
Motion \
	.with($Target, "target_property") \
	.set_damping(1000.0) \ # 減衰係数が大きすぎる
	.limit_overdamping() \ # 臨界減衰になるよう減衰比を調整
	.to(100.0)
```

これにより、ある程度予測可能な期間内で静止状態に移行します。



----



#### オーバーシュートを制限したい

最終位置を越えたとき強制的に静止状態に移行させることができます。

```GDScript
Motion \
	.with($Target, "target_property") \
	.limit_overshooting() \ # 100.0 を跨ぐ瞬間静止させる
	.to(100.0)
```



----



#### 間を設けてからアニメーションを開始したい

遅延を与えることができます。

```GDScript
Motion \
	.delay(1.0) \ # 1 秒待ってから
	.to(100.0)    # 100 までアニメーション
```



----



#### float 以外をアニメーションさせたい

以下の型に対応していますのでおそらくそのまま使えます。

* float (RealMotionState.gd で実装)
* Vector2 (Vector2MotionState.gd で実装)
* Vector3 (Vector3MotionState.gd で実装)
* Color (ColorMotionState.gd で実装)
* PoolRealArray (RealArrayMotionState.gd で実装)
* PoolVector2Array (Vector2ArrayMotionState.gd で実装)
* PoolVector3Array (Vector3ArrayMotionState.gd で実装)
* PoolColorArray (ColorArrayMotionState.gd で実装)



----



#### アニメーションの開始や終了のタイミングを知りたい

いくつかのシグナルを公開しています。

* `Motion.started` 開始したとき
* `Motion.updated` 変化したとき
* `Motion.finished` 終了したとき
* `Motion.all_finished` すべて終了したとき



----



#### プロパティの中のプロパティをアニメーションさせたい

`NodePath` による指定ができます。

```GDScript
Motion.with($Target, "position:x")
```

例えば、`position` をアニメーションしているとき、`position:x` のアニメーションを指定すると、
重複している内部のステートはマージされないためアニメーションが被らないよう気を付けてください。(今後対応したい)



----



#### 独自の補間ロジックを実装したい

`MotionGenerator` と `MotionGeneratorInit` を継承し実装します。
`Motion.context` を経由しイニシエータを渡すと独自のアニメーションをさせることができます。(Tween のコピーを実装したいが使わないので保留中)



----



#### 自分のバネの構成を保存しておきたい

バネの構成を保存しておくことができます。

```GDScript
var generator_init := SpringMotionGeneratorInit.new()
generator_init.stiffness = 300.0
generator_init.damping = 15.0
generator_init.mass = 3.0
Motion.register_spring_preset("MY_SPRING", generator_init)

Motion \
	.with($Target, "target_property", "MY_SPRING") \
	.to(100.0)
```



## 注意

`Motion.with*()` や `Motion.stop*()` の返すビルダオブジェクトは使い捨てであり、メンバーへ保存してはいけないし、うまく動作しなくなります。

もし構成を変数として保存したい場合は、`Motion.register_*_preset()` もしくは、`Motion.create_spring()` や `Motion.create_decay()` を使います。後者の返すオブジェクトはメンバーとして保存しておくことができます。



## そのほか

MIT ([ここ](LICENSE.md)) です。使い勝手の改善などについて要望があれば歓迎します。[@ydipeepo](https://twitter.com/ydipeepo) まで。
