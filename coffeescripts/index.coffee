$(document).ready ()->
	isCanvasSupported = ->
		elem = document.createElement('canvas')
		return !!(elem.getContext && elem.getContext('2d'))
	unless isCanvasSupported()
		return alert "あなたのブラウザはCanvasが使えないです"

	canvas = $('#c')[0]
	stage = new createjs.Stage canvas

	contentManager = new ContentManager stage, canvas.width, canvas.height, ->
		platform = new GamePlatform(stage, canvas.width, canvas.height, this)
		platform.startGame()
	contentManager.startDownload()

