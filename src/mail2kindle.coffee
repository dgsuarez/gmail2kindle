spawn = require('child_process').spawn
nodemailer = require 'nodemailer'
tmp = require 'tmp'
fs = require 'fs'

convert = (file, callback) ->
  tmp.file postfix: ".mobi", (err, dest) ->
    callback(err, null) if err
    p = spawn "ebook-convert", [file, dest]
    p.stdout.on "data", (data) -> console.log('' + data)
    p.stderr.on "data", (data) -> console.log('' + data)
    p.on "exit", (code) ->
      err = code != 0 ? "error processing" : null
      callback(err, dest)

mail_file = (transport, to, path, callback) ->
  fs.readFile path, (err, contents) ->
    opts =
      to: to
      subject: "new document"
      attachments: [
        filename: "document.mobi"
        contents: contents
      ]
    transport.sendMail opts, (err, resp) ->
      callback(err, resp)

