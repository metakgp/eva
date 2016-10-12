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

channel_info = "Hey there, welcome to Metakgp's Slack!\n
The following is a list of channels and the type of discussions
 that each channel is designed to contain:\n
- #mfqp-source -> Discussions about the mfqp-source project (Checkout https://github.com/metakgp/mfqp-source\n
- #meta-x -> Disussions related to ongoing meta-x projects (naarad, mfqp, mftp, mcmp) and future moonshots\n
- #book-club -> Read a book that you want to talk about? Want to read a book that someone else talked about? Go here!\n
- #server -> Server related discussion. We run a Digital Ocean droplet\n
- #general -> General discussions that don't fit anywhere else
- #cute-animal-pics -> `@eva cat bomb 4` or `@eva pug bomb 4` in this channel should tell you more!\n
- #random -> Unrelated rants and discussions, anything really
"


plugin = (robot) ->
  robot.respond /(hello|hi)/i, (msg) ->
      msg.send "Hi @#{msg.message.user.name}!"

  robot.respond /how are you/i, (msg) ->
    msg.send "Things are good, @#{msg.message.user.name}! What about you?"

  robot.hear /send joining message to me/i, (msg) ->
    if msg.message.room == "random"
      robot.send {room: msg.message.user.name}, channel_info

  robot.enter (msg) ->
    if msg.message.room == "general"
      randNum = Math.floor(Math.random() * 10)
      msg.send welcome_message_1[randNum % (welcome_message_1.length-1)] + \
        '@' + msg.message.user.name + welcome_message_2[randNum % \
          (welcome_message_2.length-1)] + welcome_message_3[randNum % \
            (welcome_message_3.length-1)]

module.exports = plugin
