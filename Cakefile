fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'
fs = require 'fs'

task 'watch', 'Watch src/ and lib/public/javascripts for changes', ->
	coffee = spawn 'coffee', ['-w', '-c', '-o', 'javascripts', 'coffeescripts']
	coffee.stderr.on 'data', (data) ->
		process.stderr.write data.toString()
	coffee.stdout.on 'data', (data) ->
		print data.toString()

