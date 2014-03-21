# Setup event trap
process.stdin.resume()
process.on 'SIGINT', -> bot.disconnect("Ctrl+C from console.", process.exit)

console.log "Stating bot"

util = require 'util'
irc = require "irc"
config = require '../config'
package_info = require '../package'
UrlDetector = require './url_detector'
PluginManager = require './plugins'

bot = new irc.Client config.server, config.nick, 
  channels: config.channels
  password: config.password
  userName: config.username
  realName: config.realname
  debug:    true

bot.commandList = {}

# Optional error handler
if config.crash_on_error
  console.log("ERROR HANDLING OFF, ALL ERROR EVENTS WILL RESULT IN CRASH")
  bot.addListener 'error', ->(msg) console.log('error: ', msg)

# Command Processor
bot.addListener "message", (who, channel, message) ->
  console.log "#{who} => #{channel}: #{message}" 
  if 0 == message.indexOf config.trigger
    args = message.split(" ")
    command = args.shift().substr(config.trigger.length)
    bot.emit "command", channel, who, command, args
    # FIXME: use the event listener to determine if there's a command registered.
    if bot.commandList[command]
      bot.emit "command_#{command}", channel, who, args
    else
      bot.emit "missing_command", channel, who, command, args
  else if url = UrlDetector.has_url(message)
    if not bot.emit "message_with_url:#{url.host}", channel, who, message, url
      bot.emit "message_with_url", channel, who, message, url

bot.addMissingCommandHandler = (callback) -> 
  return false if @missingCommandHanlder
  @missingCommandHanlder = callback
  bot.addListener "missing_command", @missingCommandHanlder
  return true

bot.removeMissingCommandHandler = () -> 
  return false if not @missingCommandHanlder
  bot.removeListener "missing_command", @missingCommandHanlder
  @missingCommandHanlder = null
  return true

bot.addCommand = (command, callback)-> # callback = (channel, who, args)
  return false if @commandList[command]
  @commandList[command] = callback
  @addListener("command_#{command}", callback)
  return true

bot.removeCommand = (command) -> 
  return false if not @commandList[command]
  @removeListener("command_#{command}", @commandList[command])
  delete @commandList[command]
  return true

bot.start = ()->
  @addCommand "reload-plugins", (channel, who, args) =>
    if who == "epochwolf"
      @say channel, "Okay."
      @plugins.__rescan()
      @say channel, "Done."
    else
      @say channel, "Nope."
  @plugins = new PluginManager bot, config

bot.start()
