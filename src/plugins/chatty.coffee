class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "chatty"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      action: [@waveBackOnAction]
      join: [@welcomeOnJoin]
    @__commands = 
      hi: @greeterCmd
    @__autoload = false

  setup: () =>
    console.log "Chatty plugin loaded"

  teardown:() =>
    console.log "Chatty plugin unloaded"

  greeterCmd: (channel, who, args) => 
    @bot.say channel, "Hello"

  welcomeOnJoin: (channel, who) =>
    if who == @config.nick
      @bot.say channel, "Hi everyone!"
    else
      @bot.action channel, "welcomes #{who}"

  waveBackOnAction: (who, channel, message) =>
    @bot.action channel, "waves back" if message == "waves"

module.exports = Plugin