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
#  hi - Same as hello
#  how are you - Responds with a polite greeting
#  send the joining message to me - Responds with the joining message that is sent to users when they first join this slack
#  tell me more about <channel-name> - Send long description containing information about the channel
#
#
# Author:
#  nevinvalsaraj
#  icyflame
#  thealphadollar


# Returns a random number between 0 and up_lim-1 (both inclusive)
randNum = (up_lim) ->
  return (Math.floor(Math.random() * 1e4) % up_lim)

welcome_message_1 = [
  "Hi ",
  "Hola ",
  "Hey ",
  "Hey there, ",
  "Yo "
]

welcome_message_2 = [
  "! Looks like you're new to MetaKGP slack, welcome.",
  "! Looks like this is your first time at MetaKGP slack, welcome.",
  "! Welcome to MetaKgp!",
].join('\n')

welcome_message_3 = [
  "Did I mention that everyone is waiting for you to say 'hi' in #general.",
  "It would be exciting if you tell everyone something about yourself in #general!"
]

welcome_message_4 = " It will be really helpful if you update your Slack profile with real name, just so people can recognize you using all your monikers!"
channels_info = [
  "* #mfqp-source -> Discussions about the mfqp-source project",
  "* #meta-x -> Disussions related to ongoing meta-x projects (naarad, mfqp, mftp, mcmp) and future moonshots",
  "* #book-club -> Read a book that you want to talk about? Want to read a book that someone else talked about? Go here!",
  "* #server -> Server related discussion. We run a Digital Ocean droplet",
  "* #demo-day -> Demo your projects on the upcoming demo day and get a wider audience for your project. You also enter a raffle to win Rs. 1000!",
  "* #general -> General discussions that don't fit anywhere else",
  "* #random -> Unrelated rants and discussions, anything really",
  "",
  "*Links on other websites:*",
  "",
  "GitHub: https://github.com/metakgp",
  "Wiki: https://wiki.metakgp.org"
].join('\n')
googleGroupInvite = "We have a google group where we post all the latest announcements. It is a low volume group, so there won't be any unwanted email in your inbox. We hate those too! You can join it by going to https://goo.gl/Uk4Lfl."

channel_descriptions = JSON.parse require("fs").readFileSync("channel_long_descriptions.json")
sorry_no_information = "Ooops! It seems we don't know anything more about this channel! Sorry, you are a pioneer!"

complete_welcome_msg = (username) ->
  return [
    "*Welcome to Metakgp!*",
    welcome_message_1[randNum(welcome_message_1.length)] + '@' + username + "!",
    "",
    welcome_message_3[randNum(welcome_message_3.length-1)] + welcome_message_4,
    "",
    "*A little bit more about the channels on this Slack:*",
    channels_info,
    "",
    "*Other communication channels:*",
    googleGroupInvite
  ].join('\n')

more_about_channel = (channel_name) ->
  more_about_the_channel = sorry_no_information
  if channel_descriptions[msg.message.room]
    more_about_the_channel = channel_descriptions[msg.message.room]
  return more_about_the_channel

plugin = (robot) ->
  robot.respond /(hello|hi)/i, (msg) ->
      msg.send "Hi @#{msg.message.user.name}!"

  robot.respond /how are you/i, (msg) ->
    msg.send "Things are good, @#{msg.message.user.name}! What about you?"

  robot.respond /(Good|Great|good|great) job(!)?/i, (msg) ->
      msg.send "Thank you @#{msg.message.user.name} :smiley:"

  robot.respond /(send the )?joining message( to me)?/i, (msg) ->
    robot.send {room: msg.message.user.name}, complete_welcome_msg(msg.message.user.name)

  robot.respond /(tell me )?more about \#?([a-z-]+)/, (msg) ->
    channel_name = msg.match[2]
    robot.send {room: msg.message.user.name}, more_about_channel(channel_name)

  robot.enter (msg) ->
    if msg.message.room == "general"
      robot.send {room: msg.message.user.name}, complete_welcome_msg(msg.message.user.name)

    else
      robot.send {room: msg.message.user.name}, "Hey #{msg.message.user.name}, You just joined ##{msg.message.room}, here's some information about this channel!"
      robot.send {room: msg.message.user.name}, more_about_channel(msg.message.room)

module.exports = plugin
