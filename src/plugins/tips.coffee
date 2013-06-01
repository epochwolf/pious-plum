class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "tips"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__commands = 
      add: @add
      remove: @remove
    @__missingCommandHandler = @missingCommand
    @__autoload = true

  setup: () =>
    @tips = new(require('../kvstore'))("data/tips.json")

  add: (channel, who, args) => 
    if tip = args.shift()
      @tips.set tip, args.join " "
      @bot.say channel, "Tip added."

  remove: (channel, who, args) =>
    if tip = args.shift()
      @tips.set tip, null
      @bot.say channel, "Tip removed."

  missingCommand: (channel, who, command, args) =>  
    if msg = @tips.get command
      @bot.say channel, msg

module.exports = Plugin