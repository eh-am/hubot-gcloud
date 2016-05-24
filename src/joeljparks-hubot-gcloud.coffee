# Description:
#   Control Google Cloud from Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   gcloud get clusters
#
#
# Author:
#   Joel Parks <joel@parksfamily.us>
#

run_cmd = (cmd, args, cb ) ->
    spawn = require("child_process").spawn
    opts =
        env: {}
    child = spawn(cmd, args, opts)
    child.stdout.on "data", (buffer) -> cb buffer.toString()
    child.stderr.on "data", (buffer) -> cb buffer.toString()

module.exports = (robot) ->
  #robot.respond /docker restart (.*)/i, (msg) ->
    #msg.send "Restarting "+msg.match[1].replace(/[\W]+/g, "")+"..."
    #run_cmd "docker", ["restart", msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /gcloud get clusters$/i, (msg) ->
    run_cmd 'gcloud', ['container','clusters','list'], (text) -> msg.send text
