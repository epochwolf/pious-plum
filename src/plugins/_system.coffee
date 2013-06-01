util = require "util"
le_admin = "epochwolf"

class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "system"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      error: [@error_handler]
    @__commands = 
      about: @aboutCmd
      join: @joinCmd
      part: @partCmd
      quit: @quitCmd
      plugin: @pluginCmd
    @__autoload = true
    @__prevent_unload = true

  error_handler: (message) =>
    console.log "error: #{util.inspect message}"

  aboutCmd: (channel, who, args) => 
    @bot.say channel, "I am a Pious Purple IRC Bot #{package_info.version} written in Node.JS https://github.com/epochwolf/pious-purple"

  joinCmd: (channel, who, args) => 
    return @bot.say channel, "Nope." if who != le_admin
    if args[0]
      @bot.say channel, "Okay."
      @bot.join args[0]
    else
      @bot.action channel, "yawns"

  partCmd: (channel, who, args) => 
    return @bot.say channel, "Nope." if who != le_admin
    @bot.say channel, "Okay."
    @bot.part(args[0] || channel)

  quitCmd: (channel, who, args) => 
    return @bot.say channel, "Nope." if who != le_admin
    @bot.say channel, "Okay."
    @bot.disconnect("#{who} asked me to quit", process.exit)
      

  pluginCmd: (channel, who, args) =>
    return @bot.say channel, "Nope." if who != le_admin
    [subcmd, name] = args
    if subcmd == "list"
      plugins = ((if plugin.__loaded then name else "#{name} (not loaded)") for name, plugin of @bot.plugins.plugins)
      @bot.say channel, "Plugins: #{plugins.sort().join(", ")}"
    else
      plugin = @bot.plugins.get name
      if plugin
        switch subcmd
          when "load" 
            @bot.plugins.load name
            @bot.say channel, "Plugin \"#{name}\" loaded."
          when "unload" 
            @bot.plugins.unload name
            @bot.say channel, "Plugin \"#{name}\" unloaded."
          when "info" 
            @bot.say channel, "#{name} provides: #{Object.keys(plugin.__commands).join(", ")} and listens to: #{Object.keys(plugin.__listeners).join(", ")}"
          else
            @bot.say channel, "Available sub commands: load [plugin], unload [plugin], info [plugin], list"
      else
        @bot.say channel, "No plugin named \"#{name}\""

module.exports = Plugin



