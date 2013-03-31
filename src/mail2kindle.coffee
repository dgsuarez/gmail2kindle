spawn = require('child_process').spawn
nodemailer = require 'nodemailer'
tmp = require 'tmp'

convert = (file, callback) ->
  tmp.file postfix: ".mobi", (err, dest) ->
    callback(err, null) if err
    p = spawn "ebook-convert", [file, dest]
    p.stdout.on "data", (data) -> console.log('' + data)
    p.stderr.on "data", (data) -> console.log('' + data)
    p.on "exit", (code) ->
      err = code != 0 ? "error processing" : null
      callback(err, dest)

convert "sample.epub", (err, conv_file) -> console.log conv_file
    
