# # Description:
# #  Send random issues from metaKGP github to the user if asked for, otherwise
# #  send one to meta-x
# #  at random interval
# #
# # Dependencies:
# #   node-cron
# #
# # Configuration:
# #   None
# #
# # Commands:
# #   contribute - Sends a random issue to the user from github
# #   passtime - same as contribute
# #
# # Author:
# #  thealphadollar

# # # interval (in days) at which issue is sent
# # interval = 5


iterate = (labels) ->
  labels_list = (label.name for label in labels)
  return labels_list


select_random = (value) ->
  """
  returns a random number in range 0 (inclusive) to value (exclusive)
  """
  return (Math.floor(Math.random() * 1e4) % value)


send_issue_plug = (robot) ->
  robot.respond /((want to )?contribute)|((do something )?passtime)/i, (msg) ->
    """
    function to fetch random issue from metaKGP github
    returns a message
    """
    github = require('githubot')(robot)
    github.get "https://api.github.com/orgs/metakgp/repos", (repos_list) ->

      no_of_repos = Object.keys(repos_list).length
      repo = repos_list[select_random(no_of_repos)].name
      repo_url = "https://api.github.com/repos/metakgp/".concat(repo, "/issues")

      console.log(repo)

      github.get repo_url, (issues_list) ->

        no_of_issues = Object.keys(issues_list).length
        console.log(no_of_issues)
        issue_tosend = issues_list[select_random(no_of_issues)]

        
        console.log(issue_tosend)

        # if no issue was found in the repo
        if no_of_issues == 0
          console.log("zero issues")

        else
          msg_tosend = [
            "Repository: " + repo,
            "Issue: " + issue_tosend.title,
            "Created by: " + issue_tosend.user.login,
            "Labels: " + iterate(issue_tosend.labels).join(', '),
            "Description: " + issue_tosend.body,
            "Know more at " + issue_tosend.html_url
          ].join('\n')
    
          msg.send msg_tosend

module.exports = send_issue_plug