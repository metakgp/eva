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

ISSUES_TO_SHOW = 5

webpage_url = (query) ->
  # Return the url of the web page which will show the issues matching a given query on github

  return "https://github.com/issues?q=" + encodeURIComponent(query)

git_search = (msg, robot, keyword) ->
  ###
  # Fetches list of issues matching keyword/phrase
  # Argument::
  #   keyword:
  #     keyword to match in the repositories name and description.
  ###
  github = require('githubot')(robot)

  msg_to_send = [ ]

  query = keyword + " is:issue is:open org:metakgp"

  github.get "search/issues", {q: query, per_page: 6}, (issue_list) ->

    if issue_list.total_count > 0
      msg_to_send.push "Here are the top matches for your query:"
      msg_to_send.push ""

      for data, index in issue_list.items
        specific_issue_msg = "- *" + data.title + "* -> " + data.html_url
        msg_to_send.push specific_issue_msg
        if index >= (ISSUES_TO_SHOW-1)  # displaying at max 5 issues
          break

      msg_to_send.push ""
      msg_to_send.push "Find all the issues here: " + webpage_url(query)

      msg.send msg_to_send.join('\n')

    else
      msg.send "Oops! No matching issues for the keyword: " + keyword


search_issue_plugin = (robot) ->
    ###
    # Searches all github issues of the metakgp organisation for a keyword.
    #
    # Keyword can be a sentence preceded by search/query keyword.
    # -- @eva search frontend tests
    # Keyword here will be "frontend tests"
    #
    # Returns matching issues in the following format:
    # -- Matching issues for your query "" are:
    # -- *[issue_Title_1]* -> [issue_Link]
    # -- *[issue_Title_2]* -> [issue_Link]
    # -- ...
    ###

    robot.respond /(search|query) (.*)/i, (msg) ->
        keyword = msg.match[2]
        git_search(msg, robot, keyword)


module.exports = search_issue_plugin
