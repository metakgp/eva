# # Description:
# #  Send random issues from metaKGP github to the user if asked for, otherwise
# #  send one to meta-x everyday
# #
# # Dependencies:
# #   hubot-cronjob
# #   githubot
# #   remove-markdown
# #
# # Configuration:
# #   None
# #
# # Commands:
# #   contribute - Sends a random issue to the user from github
# #
# # Author:
# #  thealphadollar


# Global variable to check the depth of recussion
recur_depth = 1


to_text = (desc) ->
  """
  removes html/markdown tags from the input text
  """
  convert_to_text = require("remove-markdown")
  return convert_to_text(desc)


iterate = (labels) ->
  labels_list = (label.name for label in labels)
  return labels_list


select_random = (value) ->
  """
  returns a random number in range 0 (inclusive) to value (exclusive)
  """
  return (Math.floor(Math.random() * 1e4) % value)


git_msg = (msg, robot, in_personal, parent) ->
  """
  function to fetch and show random issue from metaKGP github
  Argument::
    in_personal:
      true: send the message where user asked
      false: send the message in metax channel
    parent:
      true: first iteration
      false: subsequent iterations
  """

  if parent
    recur_depth = 1

  github = require('githubot')(robot)
  github.get "orgs/metakgp/repos", {per_page: 100}, (repos_list) ->

    no_of_repos = Object.keys(repos_list).length
    repo = repos_list[select_random(no_of_repos)].name
    repo_url = "repos/metakgp/".concat(repo, "/issues")

    github.get repo_url, (issues_list) ->

      no_of_issues = Object.keys(issues_list).length
      issue_to_send = issues_list[select_random(no_of_issues)]

      # if no issue was found in the repo, recur into the function (max recursion depth allowed is 10)
      if no_of_issues == 0
        # console.log("zero issues")
        if recur_depth <= 10
          # console.log(recur_depth)
          git_msg(msg, robot, in_personal, false)
          recur_depth = recur_depth + 1

        else
          msg.send "No issues found, please try later :)"

      else
        msg_to_send = [
          "*Repository:* " + repo,
          "*Issue:* " + issue_to_send.title,
          "*Created by:* " + issue_to_send.user.login,
          "*Labels:* " + iterate(issue_to_send.labels).join(', '),
          "*Description:* " + to_text(issue_to_send.body),
          "*Know more at *" + issue_to_send.html_url
        ].join('\n')

        if in_personal
          msg.send msg_to_send
        else
          robot.messageRoom 'random', msg_to_send


send_issue_plugin = (robot) ->
  """
  Sends a github issue when user pings Eva with 'contribute' argument
  """
  robot.respond /((want to )?contribute)/i, (msg) ->
    git_msg(msg, robot, true, true)

  """
  Sends a github issue every saturday to random at 10 AM IST
  """
  HubotCron = require('hubot-cronjob')
  pattern = "0 10 * * SAT"
  timezone = "Asia/Kolkata"
  fn = () ->
    git_msg(null, robot, false, true)
  new HubotCron pattern, timezone, fn


module.exports = send_issue_plugin
