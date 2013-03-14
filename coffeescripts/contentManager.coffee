class ContentManager
	manifest:[
		{src:'images/Background02.png', id:'background'},
		{src:'images/BlueShip.png', id:'ship'},
		{src:'images/WalkingSquare.png', id:'square'}
	]
	constructor: (@stage, width, height, @downloadCompleteCallback)->
		@preload = new createjs.PreloadJS false # useXHR=false ローカルからファイルを読み込むのでimageタグを強要する
												# xhrはCross Origin Resource Sharingを許可しない
		@preload.onError = @handleElementError
		@preload.onFileLoad = @handleElementLoad
		@downloadProgress = new createjs.Text "-- %", "bold 18px Arial", "#fff"
		@downloadProgress.x = (width / 2)
		@downloadProgress.y = (height / 2)
		@elementLoadedCount = 0
	startDownload: ->
		@preload.loadManifest @manifest
		@stage.addChild @downloadProgress
		createjs.Ticker.addListener this
		createjs.Ticker.setInterval 50
	handleElementError: (e)=>
		alert "画像読み込み失敗 : #{e.src}"
	handleElementLoad: (e)=>
		@[e.id] = e.result
		@elementLoadedCount += 1
		if @elementLoadedCount is @manifest.length
			@stage.removeChild @downloadProgress
			createjs.Ticker.removeListener this
			@downloadCompleteCallback()
	tick: =>
		@downloadProgress.text = Math.round((@elementLoadedCount/@manifest.length) * 100) + " %"
		@stage.update()
window.ContentManager = ContentManager
