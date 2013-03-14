class GamePlatform
	constructor: (@stage, width, height, contentManager)->
		# 背景の用意
		background = new createjs.Bitmap contentManager.background
		background.setTransform 0, 0, width/400.0, height/300.0   # 背景画像は400*300でCanvasサイズと合わないので拡大する
		@stage.addChild background

		# 文字列表示
		text = new createjs.Text "Click on the characters!", "bold 24px Meiryo", "#000"
		text.x = (width/2)-(text.getMeasuredWidth()/2)
		text.y = 10
		# text.align = 'right'  # align指定はこの方法で
		@stage.addChild text

		# スプライトシートの設定
		shipSpriteSheet = new createjs.SpriteSheet
			images: [contentManager.ship]
			frames:
				width:100   # １フレームの幅を指定
				height:100  # １フレームの高さを指定
				regX:50     # 中心点（拡大縮小、回転、移動用の）を指定
				regY:50     #
			animations:
				move:
					frames: [0, 1, 2, 3, 4, 5] # アニメーションフレームの指定
					frequency: 10   # フレームごとの速度
		# スプライトアニメーションの設定
		shipAnimation = new createjs.BitmapAnimation shipSpriteSheet
		shipAnimation.x = shipAnimation.y = 100
		# スプライトシートから指定のフレームの画像を抜き取ってBitmapオブジェクトを作成する
		ship = new createjs.Bitmap createjs.SpriteSheetUtils.extractFrame shipSpriteSheet, 0
		ship.regX = ship.regY = 50 # 中心点をスプライトアニメーションに合わせる
		ship.x = ship.y = 100
		ship.onClick = =>
			shipAnimation.rotation = 90
			@stage.addChild shipAnimation
			shipAnimation.gotoAndPlay "move"
			@stage.removeChild ship
			# オブジェクトアニメーションを設定する
			createjs.Tween.get(shipAnimation)
					.to({x:width+100, scaleX:2, scaleY:2}, 1000, createjs.Ease.cubicIn)
					.to({rotation:270})
					.to({x:100, scaleX:1, scaleY:1}, 1000, createjs.Ease.cubicOut)
					.to({rotation:0}, 500)
					.wait(500)
					.call =>
						@stage.addChild ship
						@stage.removeChild shipAnimation
						shipAnimation.stop()
		@stage.addChild ship

		sqSpriteSheet = new createjs.SpriteSheet
			images: [contentManager.square]
			frames:
				width:100
				height:130
				regX:50
				regY:65
			animations:
				walk:
					frames: [0, 1, 2, 3, 4]
					frequency: 20
		sqAnimation = new createjs.BitmapAnimation sqSpriteSheet
		sqAnimation.x = 100
		sqAnimation.y = 250
		sq = new createjs.Bitmap createjs.SpriteSheetUtils.extractFrame sqSpriteSheet, 0
		sq.regX = 50
		sq.regY = 65
		sq.x = 100
		sq.y = 250
		sq.onClick = =>
			@stage.addChild sqAnimation
			sqAnimation.gotoAndPlay "walk"
			@stage.removeChild sq
			createjs.Tween.get(sqAnimation)
					.to({x:width+100}, 1000, createjs.Ease.quadInOut)
					.to({scaleX:-1})    # Y軸を中心にフリップする
					.to({x:100}, 1000, createjs.Ease.bounceOut)
					.to({scaleX:1})
					.wait(500)
					.call =>
						@stage.addChild sq
						@stage.removeChild sqAnimation
						sqAnimation.stop()
		@stage.addChild sq

		# Containerを使用してオブジェクトをまとめて管理したりもできる
#		container = new createjs.Container()
#       player = new createjs.Bitmap somethingImage
#		container.addChild player
#       player2 = new createjs.Bitmap somethingImage2
#		container.addChild player2
#		@stage.addChild container

	startGame: ->
		createjs.Ticker.userRAF = true
		createjs.Ticker.setFPS 60
		createjs.Ticker.addListener this
	tick: =>
		#
		# キー入力にあわせたキャラクタの動作やあたり判定などをここで行う
		#
		@stage.update()
window.GamePlatform = GamePlatform


