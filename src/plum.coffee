# Setup event trap
process.stdin.resume()
process.on 'SIGINT', -> bot.disconnect(process.exit)

console.log "Stating bot"

util = require 'util'
irc = require "irc"
config = require '../config'
package_info = require '../package'
bot = new irc.Client config.server, config.nick, 
  channels: config.channels

bot.addListener 'error', (message)-> console.log "error: #{util.inspect message}"

bot.addListener "join", (channel, who) ->
  if who == config.nick
    bot.say channel, "Hi everyone!"
  else
    bot.action channel, "welcomes #{who}"


bot.addListener "message", (who, channel, message) ->
  console.log "#{who} => #{channel}: #{message}" 
  if 0 == message.indexOf config.trigger
    args = message.split(" ")
    command = args.shift().substr(config.trigger.length)
    process_command channel, who, command, args

bot.addListener "action", (who, channel, message) ->
  bot.action channel, "waves back" if message == "waves"

process_command = (channel, who, command, args)->
  switch command
    when "hi" then bot.say channel, "Hello"
    when "join" 
      if who == "epochwolf"
        if args[0]
          bot.say channel, "Okay."
          bot.join args[0]
        else
          bot.action channel, "yawns"
      else 
        bot.say channel, "Nope."
    when "part"
      if who == "epochwolf"
        bot.say channel, "Okay."
        bot.part(args[0] || channel)
      else 
        bot.say channel, "Nope."
    when "quit" then bot.say channel, "I hope you enjoy my company. I'm not programmed for suicide."
    when "about" then bot.say channel, "I am a Pious Purple #{package_info.version} https://github.com/epochwolf/pious-purple"

