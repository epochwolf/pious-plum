class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "say"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__commands = {}
    @__admin_commands = 
      say: @sayCmd
    @__autoload = true

  setup: () =>
    console.log "Say plugin loaded"

  teardown:() =>
    console.log "Say plugin unloaded"

  sayCmd: (channel, who, args) => 
    say_channel = args.shift()
    say_channel = channel if say_channel == "."

    me_command = args.shift()
    me = me_command == "/me"
    args.unshift me_command unless me
    
    message = args.join(" ")

    if me
      @bot.action say_channel, message
    else
      @bot.say say_channel, message 

module.exports = Plugin