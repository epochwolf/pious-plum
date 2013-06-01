# Setup event trap
process.stdin.resume()
process.on 'SIGINT', -> bot.disconnect(process.exit)

console.log "Stating bot"

irc = require "irc"
config = require '../config'
bot = new irc.Client config.server, config.nick, 
  channels: config.channels

bot.addListener "join", (channel, who) ->
  bot.say(channel, who + ": hi!") if who != config.nick
