# Setup event trap
process.stdin.resume()
process.on 'SIGINT', -> bot.disconnect("Ctrl+C from console.", process.exit)

console.log "Stating bot"

util = require 'util'
irc = require "irc"
config = require '../config'
package_info = require '../package'
PluginManager = require('./plugins')

bot = new irc.Client config.server, config.nick, 
  channels: config.channels
  password: config.password
  userName: config.username
  realName: config.realname

bot.commandList = {}

# Command Processor
bot.addListener "message", (who, channel, message) ->
  console.log "#{who} => #{channel}: #{message}" 
  if 0 == message.indexOf config.trigger
    args = message.split(" ")
    command = args.shift().substr(config.trigger.length)
    bot.emit "command", channel, who, command, args
    if bot.commandList[command]
      bot.emit "command:#{command}", channel, who, args
    else
      bot.emit "missing_command", channel, who, command, args

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
  @addListener("command:#{command}", callback)
  return true

bot.removeCommand = (command) -> 
  return false if not @commandList[command]
  @removeListener(command, @commandList[command])
  delete @commandList[command]
  return true

bot.plugins = new PluginManager bot, config


