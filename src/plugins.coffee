fs = require 'fs'
path = require 'path'
util = require 'util'

class PluginManager
  constructor: (@bot, @config) -> 
    @plugins = {}
    @__scan()

  load: (name) ->
    if plugin = @plugins[name]
      console.log "Load Plugin: #{name}"
      if plugin.setup
        plugin.setup() 
      if plugin.__missingCommandHandler
        @bot.addMissingCommandHandler plugin.__missingCommandHandler 
      for event, callbacks of plugin.__listeners
        for callback in callbacks
          @bot.addListener event, callback
      for command, callback of plugin.__commands
        @bot.addCommand command, callback
      for command, callback of plugin.__admin_commands
        do (callback) => 
          @bot.addCommand command, (channel, who, args) =>
            return @bot.say channel, "Nope." unless who in @config.bot_admins
            callback(channel, who, args)
      plugin.__loaded = true
      return true
    else
      console.log "Load Plugin: #{name} (error, no plugin by this name)"
      return false


  unload: (name, force=true) ->
    if plugin = @plugins[name]
      console.log "Unload Plugin: #{name}"
      return false if !force && plugin.__prevent_unload
      if plugin.teardown
        plugin.teardown() 
      if @bot.missingCommandHandler == plugin.__missingCommandHandler
        @bot.removeMissingCommandHandler()
      for event, callbacks of plugin.__listeners
        for callback in callbacks
          @bot.removeListener event, callback
      for command, callback of plugin.__commands
        @bot.removeCommand command
      plugin.__loaded = false
      return true
    else
      console.log "Unload Plugin: #{name} (error, no plugin by this name)"
      return false

  get: (name) ->
    @plugins[name]

  getAllNames: () ->
    Object.keys @plugins

  getAllLoadedNames: () ->
    Object.keys((name for name, plugin of @plugins when plugin.__loaded))

  __rescan: ->
    for name, plugin of @plugins
      @unload(name, true) if plugin.__loaded
      delete require.cache[plugin.__required_as]
    @plugins = {}
    @__scan()
    
  __scan: ->
    files = fs.readdirSync(path.join(__dirname, 'plugins'))
    for file in files
      require_file = fs.realpathSync path.join(__dirname, 'plugins', file)
      plugin = new(require(require_file))(@bot, @config)
      @plugins[plugin.__name] = plugin
      plugin.__filename = file
      plugin.__required_as = require_file
      plugin.__loaded = false
      @load plugin.__name if plugin.__autoload

module.exports = PluginManager