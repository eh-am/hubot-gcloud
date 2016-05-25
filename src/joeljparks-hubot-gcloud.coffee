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
#   hubot register gcloud cluster <clustername> - Gets credentials for the specified gcloud cluster
#   hubot create gcloud cluster <clustername> - Creates a GKE cluster with the specified name
#   hubot get gcloud clusters - Lists all the GKE clusters for the project
#   hubot get gcloud config - Lists the current Gcloud config
#   hubot get gcloud pods - Lists the running Kubernetes pods
#   hubot get gcloud services - Lists the running Kubernetes services
#   hubot get gcloud deployments - List the running Kubernetes deployments
#   hubot get gcloud instances - List the running GCE instances
#   hubot get gcloud path - Returns the PATH for gcloud script execution
#   hubot describe gcloud services <servicename> - Returns details of specified service.  No service specified returns all services.
#   hubot describe gcloud deployments <deployment> - Returns details of specified deployment.  No service specified returns all deployment.
#   hubot describe gcloud pods <pod> - Returns details of specified pod.  No service specified returns all pods.
#   hubot destroy gcloud services <servicename> - Deletes the service and deployment for the specified service.
#   hubot destroy gcloud cluster <clustername> - Deletes the specified GKE cluster.
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
    run_cmd 'gcloud', ['container','clusters','list'], (text) -> msg.send text

  robot.respond /get gcloud config$/i, (msg) ->
    run_cmd 'gcloud', ['config','list'], (text) -> msg.send text

  robot.respond /get gcloud pods$/i, (msg) ->
    run_cmd 'kubectl', ['get','pods', '--output=wide'], (text) -> msg.send text

  robot.respond /get gcloud services$/i, (msg) ->
    run_cmd 'kubectl', ['get','services', '--output=wide'], (text) -> msg.send text

  robot.respond /get gcloud deployments$/i, (msg) ->
    run_cmd 'kubectl', ['get','deployments', '--output=wide'], (text) -> msg.send text

  robot.respond /create gcloud cluster(.*)/i, (msg) ->
    run_cmd 'gcloud', ['container', 'clusters', 'create', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /destroy gcloud cluster(.*)/i, (msg) ->
    run_cmd 'gcloud', ['container', 'clusters', 'delete', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /describe gcloud pods(.*)/i, (msg) ->
    run_cmd 'kubectl', ['describe', 'pods', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /describe gcloud services(.*)/i, (msg) ->
    run_cmd 'kubectl', ['describe', 'services', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /describe gcloud deployments(.*)/i, (msg) ->
    run_cmd 'kubectl', ['describe', 'deployments', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /destroy gcloud services(.*)/i, (msg) ->
    msg.send "Destroying the service"+msg.match[1].replace(/[\W]+/g, "")+"..."
    run_cmd 'kubectl', ['delete', 'services', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text
    msg.send "Destroying the deployment"+msg.match[1].replace(/[\W]+/g, "")+"..."
    run_cmd 'kubectl', ['delete', 'deployments', msg.match[1].replace(/[\W]+/g, "")], (text) -> msg.send text

  robot.respond /get gcloud instances$/i, (msg) ->
    run_cmd 'gcloud', ['compute','instances','list'], (text) -> msg.send text

  robot.respond /get gcloud path$/i, (msg) ->
    run_cmd 'printenv', [],(text) -> msg.send text
