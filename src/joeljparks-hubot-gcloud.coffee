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
#   register gcloud cluster <clustername> - Gets credentials for the specified gcloud cluster
#   get gcloud clusters - Lists all the GKE clusters for the project
#   get gcloud config - Lists the current Gcloud config
#   get gcloud pods - Lists the running Kubernetes pods
#   get gcloud services - Lists the running Kubernetes services
#   get gcloud deployments - List the running Kubernetes deployments
#   get gcloud instances - List the running GCE instances
#   get gcloud path - Returns the PATH for gcloud script execution
#
# Author:
#   Joel Parks <joel@parksfamily.us>
#

run_cmd = (cmd, args, cb ) ->
    spawn = require("child_process").spawn
    opts =
        env: {
          PATH: '/home/joel/google-cloud-sdk/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games'
          HOME: '/home/joel'
        }
    child = spawn(cmd, args, opts)
    child.stdout.on "data", (buffer) -> cb buffer.toString()
    child.stderr.on "data", (buffer) -> cb buffer.toString()

module.exports = (robot) ->
  robot.respond /register gcloud cluster (.*)/i, (msg) ->
    msg.send "Registering "+msg.match[1].replace(/[\W]+/g, "")+"..."
    run_cmd 'gcloud', ['container', 'clusters', 'get-credentials', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /get gcloud clusters$/i, (msg) ->
    run_cmd 'gcloud', ['container','clusters','list','--format="table[box,title=Clusters](clusters[].name, clusters[].status)"'], (text) -> msg.send text

  robot.respond /get gcloud config$/i, (msg) ->
    run_cmd 'gcloud', ['config','list'], (text) -> msg.send text

  robot.respond /get gcloud pods$/i, (msg) ->
    run_cmd 'kubectl', ['get','pods'], (text) -> msg.send text

  robot.respond /get gcloud services$/i, (msg) ->
    run_cmd 'kubectl', ['get','services'], (text) -> msg.send text

  robot.respond /get gcloud deployments$/i, (msg) ->
    run_cmd 'kubectl', ['get','deployments'], (text) -> msg.send text

  robot.respond /get gcloud instances$/i, (msg) ->
    run_cmd 'gcloud', ['compute','instances','list','--format="table[box,title=Instances](name, status)"'], (text) -> msg.send text

  robot.respond /get gcloud path$/i, (msg) ->
    run_cmd 'printenv', [],(text) -> msg.send text
