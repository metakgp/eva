# Description:
#  Welcome new members to the group and respond to small talk.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  hello - Responds with a cheery message
#  hi
#  how are you
#
# Author:
#  nevinvalsaraj

plugin = (robot) ->
  robot.respond /(hello|hi)/i, (msg) ->
      msg.send "Hi #{msg.message.user.name}!"

  robot.respond /how are you/i, (msg) ->
    msg.send "Things are good, #{msg.message.user.name}! What about you?"

  robot.enter (msg) ->
    if msg.message.room == "general"
      msg.send "Welcome, @#{msg.message.user.name}! What brings you to MetaKgp?"

module.exports = plugin
