# Description
#   Use Hubot to manage your Google Cloud environment
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   joeljparks <joel@parksfamily.us>

module.exports = (robot) ->
  robot.respond /(cmd)/i, (msg) ->
    doing = spawn 'ls', ['-la']
    doing.stdout.on 'data', (data) ->
      msg.send data.toString()
