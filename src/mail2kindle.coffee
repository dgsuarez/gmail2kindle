spawn = require('child_process').spawn
nodemailer = require 'nodemailer'
tmp = require 'tmp'
fs = require 'fs'

convert = (file, callback) ->
  tmp.file postfix: ".mobi", (err, dest) ->
    if err
      callback(err, null)
      return
    p = spawn "ebook-convert", [file, dest]
    p.stdout.on "data", (data) -> console.log('' + data)
    p.stderr.on "data", (data) -> console.log('' + data)
    p.on "exit", (code) ->
      err = code != 0 ? "error processing" : null
      callback(err, dest)

mail_file = (transport, to, path, callback) ->
  fs.readFile path, (err, contents) ->
    if err
      callback(err, null)
      return
    opts =
      to: to
      subject: "new document"
      attachments: [
        filename: "document.mobi"
        contents: contents
      ]
    transport.sendMail opts, (err, resp) ->
      callback(err, resp)

convert_and_send = (transport, to, path, callback) ->
  convert path, (err, conv_path) ->
    if err
      callback(err, null)
      return
    mail_file transport, to, conv_path, (err, status) ->
      console.log "sent #{path}"
      callback(err, path)

send_files = (transport, to, files) ->
  file_count = files.length
  on_sent = () ->
    file_count -= 1
    transport.close() if file_count <= 0
  convert_and_send(transport, to, file, on_sent) for file in files

