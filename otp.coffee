through = require('through')
_ = require("underscore")
fs = require("fs")
root = exports ? this
root.offsets = {}
tenMb = 1024*1024*10
key = fs.readFileSync("key")

usage = (expected) ->
  console.log "Missing argument expecting #{expected}"
  process.exit 1

xor = (v1,v2) ->
  new Buffer(_(v1).map((e,i) ->
      v2[i] ^ e
  ))

exports.encryptor = (identifier,offset) ->
   console.log "Init encryptor with offset #{offset}"
   _offset = offset
   root.offsets[identifier] = _offset
   process.stdout.write '\u001B[2J\u001B[0;0f'
   through((data) ->
     end_offset = _offset + data.length
     @queue(xor(data,key.slice(_offset,end_offset)))
     _offset += data.length
     root.offsets[identifier] = _offset
     console.log root.offsets
    )

exports.validateArgs = (actual,expected) ->
  actualKeys = _.keys(actual)
  do usage(expected) if actualKeys.length < expected.length
  _.each expected, (k) ->
    do usage(expected) if actualKeys.indexOf(k) == -1

process.on 'SIGINT', () ->
  console.log "Logging offsets"
  console.log root.offsets
  process.exit 0

exports.tenMb = tenMb
