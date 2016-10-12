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
welcome_message_1 = [
  "Hi ",
  "Hola ",
  "Hey ",
  "Hey there, "
]

welcome_message_2 = [
  "! Looks like you're new here.",
  "! Looks like this is your first time here.",
  "! Welcome to MetaKgp!",
]

welcome_message_3 = [
  " Why don't you introduce yourself?",
  " Why don't you tell us a bit about you?"
]


plugin = (robot) ->
  robot.respond /(hello|hi)/i, (msg) ->
      msg.send "Hi @#{msg.message.user.name}!"

  robot.respond /how are you/i, (msg) ->
    msg.send "Things are good, @#{msg.message.user.name}! What about you?"

  robot.hear /test me/i, (msg) ->
    if msg.message.room == "random"
      robot.send {room: msg.message.user.name}, "Hey, reached out to me?"

  robot.enter (msg) ->
    if msg.message.room == "general"
      robot.send {room: msg.message.user.name}, "Hey, you can talk to me in case you want to know more!"
      randNum = Math.floor(Math.random() * 10)
      msg.send welcome_message_1[randNum % (welcome_message_1.length-1)] + \
        '@' + msg.message.user.name + welcome_message_2[randNum % \
          (welcome_message_2.length-1)] + welcome_message_3[randNum % \
            (welcome_message_3.length-1)]

module.exports = plugin
