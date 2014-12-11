createKey = (fn, size) ->
  dd = spawn("dd", [
    "if=/dev/random"
    "of=" + fn
    "bs=1048576"
    "count=" + size
  ])
  dd.stdout.pipe process.stdout

ArgumentParser = require("argparse").ArgumentParser
spawn = require("child_process").spawn
parser = new ArgumentParser(
  version: "0.0.1"
  addHelp: true
  description: "Key builder"
)

parser.addArgument [
  "-s"
  "--size"
],
  help: "Size in Mb"
  required: true

parser.addArgument [
  "-n"
  "--name"
],
  help: "Filename"
  required: true

args = parser.parseArgs()
createKey args.name, args.size
