# Description:
#   Checks if batman is fighting crime on MetaKGP wiki.
#
#   Sssssh! batman never sleeps.
#
#
# Notes:
#   Vivek Rai (@xtinct, @vivekiitkgp)
#

{spawn} = require 'child_process'

batman_happy = [
  'batman is up and running!',
  'batman never sleeps!',
  'batman is monitoring MetaKGP from the shadows!'
]

batman_sad = [
  'batman needs its maintainer!',
  'batman is down!',
  'batman needs help!'
]

module.exports = (robot) ->

  robot.respond /batman/, (res) ->
    top = spawn 'ps', ['f']

    randNum = Math.floor(Math.random() * 10)

    top.stdout.on 'data', (data) ->
      out = data.toString().trim()
      if out.indexOf('batman') != -1
        res.send batman_happy[randNum % batman_happy.length]
      else
        res.send batman_sad[randNum % batman_sad.length]
