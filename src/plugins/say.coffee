class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "say"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__commands = 
      say: @sayCmd
    @__autoload = true

  setup: () =>
    console.log "Say plugin loaded"

  teardown:() =>
    console.log "Say plugin unloaded"

  sayCmd: (channel, who, args) => 
    say_channel = args.shift()
    message = args.join(" ")
    if say_channel == "."
      say_channel = channel
    @bot.say say_channel, message 

module.exports = Plugin