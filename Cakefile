fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

compile = (from, to) ->

build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

task 'build', 'Build', ->
  build()
