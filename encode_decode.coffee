fs = require("fs")
_ = require("underscore")
pad = require("pad")
PNG = require("pngjs").PNG
blockSize = 8
endChar =  pad(blockSize,"","0")
message = "AWESOME"

fail = (msg) ->
  console.log msg
  process.exit 1

decodeMessageFromPixels = (pixels) ->
  getNthBlock = (s, n, blockSize) -> s.slice(n*blockSize,(n+1)*blockSize)
  getFirstBit = (word) -> word & 1
  charFromBinaryCharCode = (o) -> String.fromCharCode(parseInt(o,2))

  lastBitsOfEachPixels = _.map(pixels, getFirstBit)
  blockRange = _.range( lastBitsOfEachPixels.length / blockSize )
  binCharacters = _.map(blockRange, (n) ->
    getNthBlock(lastBitsOfEachPixels,n,blockSize).join(""))
  endCharBlockIdx = binCharacters.indexOf(endChar)
  do fail("No message found") if endCharBlockIdx == -1
  messageCharacters = _.reject(binCharacters, (o,i) -> i > endCharBlockIdx)
  _.map(messageCharacters, charFromBinaryCharCode).join("")

encodeMessageToPixels = (message, pixels) ->
  toBinaryCharCode = (o) -> o.charCodeAt(0).toString(2)
  toBlockBinaryString = (o) -> pad(blockSize, toBinaryCharCode(o), "0")
  setFirstBit = (word, value) -> (word & 0) | value
  getBinStrFromString = (m) -> _(m).map(toBlockBinaryString).join("")+endChar

  binstream = getBinStrFromString(message)
  do fail("Image is too small to hold data") if pixels.length < binstream.size
  _.each(binstream, (bit, idx) -> pixels[idx] = setFirstBit(pixels[idx], bit))

decodeMessageFromFile = (filename, callback) ->
  fs.createReadStream(filename).pipe(new PNG(filterType: 4)).on "parsed", ->
    callback( decodeMessageFromPixels @data )

encodeMessageToFile = (filename, message, outfilename, callback) ->
  fs.createReadStream(filename).pipe(new PNG(filterType: 4)).on "parsed", ->
    encodeMessageToPixels(message, @data)
    @pack().pipe fs.createWriteStream(outfilename)
    @on("end",callback)

encodeMessageToFile("in.png", message, "out2.png", () ->
  decodeMessageFromFile("out2.png", console.log)
)
