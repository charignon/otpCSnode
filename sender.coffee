net = require("net")
otp = require("./otp")
argv = require('minimist')(process.argv.slice(2))

expectedArgs = ["localPort", "serverPort", "clientOffset", "serverOffset", "host"]
otp.validateArgs(argv, expectedArgs)

serverPort = Number(argv.serverPort)
localPort = Number(argv.localPort)
host = argv.host
serverOffset = Number(argv.serverOffset)
clientOffset = Number(argv.clientOffset)

outBoundSocket = net.createConnection(serverPort, host)
net.createServer((inBoundSocket) ->
  outBoundSocket.pipe(otp.encryptor("server",serverOffset)).pipe(inBoundSocket)
  inBoundSocket.pipe(otp.encryptor("client",clientOffset)).pipe(outBoundSocket)
).listen(localPort)
