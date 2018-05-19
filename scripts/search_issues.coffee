# # Description:
# #  Search a keyword or phrase in all issues of metakgp organisation
# #
# # Dependencies:
# #   githubot
# #
# # Configuration:
# #   None
# #
# # Commands:
# #   search/query - searches a keyword in all issues and returns link of matching issues
# #
# # Author:
# #  thealphadollar


git_search = (msg, robot, keyword) ->
  """
  Fetches list of issues matching keyword/phrase

  Argument::
    keyword:
      keyword to match in the repositories name and description.
  """

  github = require('githubot')(robot)

  query = keyword + "org:metakgp"
  github.get "search/issues", {q: query, per_page: 6}, (issue_list) ->

    if issue_list.total_count > 0
      if issue_list.total_count == 1
        msg_to_send = [
          "Matching issue for your query \"" + keyword + "\" is:\n"
          ]
      else if issue_list.total_count <= 5
        msg_to_send = [
          "Matching issues for your query \"" + keyword + "\" are:\n"
          ]
      else
        msg_to_send = [
          "Top five matching issues for your query \"" + keyword + "\" are:\n"
          ]

      for data, index in issue_list.items
        specific_issue_msg = "*" + data.title + "* -> " + data.html_url
        msg_to_send.push specific_issue_msg
        if index == 4  # displaying at max 5 issues
          break

      msg.send msg_to_send.join('\n')

    else
      msg.send "Oops! No matching issues for \"" + keyword + "\"."


search_issue_plugin = (robot) ->
    """
    Searches all github issues of the metakgp organisation for a keyword.

    Keyword can be a sentence preceded by search/query keyword.
    -- @eva search frontend tests
    Keyword here will be "frontend tests"

    Returns matching issues in the following format:
    -- Matching issues for your query "" are:
    -- *[issue_Title_1]* -> [issue_Link]
    -- *[issue_Title_2]* -> [issue_Link]
    -- ...
    """
    robot.respond /(search|query) (.*)/i, (msg) ->
        keyword = msg.match[2]
        git_search(msg, robot, keyword)


module.exports = search_issue_plugin

