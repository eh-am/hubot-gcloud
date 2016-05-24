# Description
#   Use Hubot to manage your Google Cloud environment
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
    directory - <get the directory listing on the server>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   joeljparks <joel@parksfamily.us>

module.exports = (robot) ->
  robot.respond /directory/i, (msg) ->
    doing = spawn 'ls', ['-la']
    doing.stdout.on 'data', (data) ->
      msg.send data.toString()
