class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "tips"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = {}
    @__commands = 
      add: @add
      remove: @remove
      show: @showTip
    @__missingCommandHandler = @missingCommand
    @__autoload = true

  setup: () =>
    @tips = new(require('../kvstore'))("data/tips.json")

  showTip: (channel, who, args) =>
    command = args[0]
    if msg = @tips.get command
      @bot.say channel, "Tip: #{msg}"
    else
      @bot.say channel, "No tip by that name."

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
      msg = msg.replace("{nick}", who).replace("{channel}", channel).replace("{args}", args.join(" "))
      for arg, index in args
        msg = msg.replace "{arg#{index+1}}", arg
      if msg.match(/^\/me /)
        msg = msg.replace(/^\/me /, "")
        @bot.action channel, msg
      else
        @bot.say channel, msg

module.exports = Plugin