# Description:
#   Script to get Eva to crack a Chuck Norris joke.
#
# Notes:
#   Jokes obtained from International Chuck Norris Database via their REST API
#   http://icndb.com

CHUCK_NORRIS_JOKES_DB_URL = 'http://api.icndb.com/jokes/random'

module.exports = (robot) ->

  robot.respond /chuck()?(norris)?/i, (msg) ->
    msg.robot.http(CHUCK_NORRIS_JOKES_DB_URL)
      .query({limitTo: 'nerdy'})
      .get() (err, res, body) ->
        data = JSON.parse body
        joke = data.value.joke
        msg.send joke

