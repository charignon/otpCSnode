net = require("net")
otp = require("./otp")
argv = require('minimist')(process.argv.slice(2))

expectedArgs = ["localPort", "servicePort", "serverOffset", "clientOffset"]
otp.validateArgs(argv, expectedArgs)

servicePort = Number(argv.servicePort)
localPort = Number(argv.localPort)
serverOffset = Number(argv.serverOffset)
clientOffset = Number(argv.clientOffset)

net.createServer((outBoundSocket) ->
  inBoundSocket =  net.createConnection(servicePort, "localhost")
  outBoundSocket.pipe(otp.encryptor("client", clientOffset)).pipe(inBoundSocket)
  inBoundSocket.pipe(otp.encryptor("server",serverOffset)).pipe(outBoundSocket)
).listen Number(localPort)
