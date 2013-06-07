fs = require 'fs'
path = require 'path'

class PluginManager
  constructor: (@bot, @config) -> 
    @plugins = {}
    @__scan()

  load: (name) ->
    if plugin = @plugins[name]
      if plugin.setup
        plugin.setup() 
      if plugin.__missingCommandHandler
        @bot.addMissingCommandHandler plugin.__missingCommandHandler 
      for event, callbacks of plugin.__listeners
        for callback in callbacks
          @bot.addListener event, callback
      for command, callback of plugin.__commands
        @bot.addCommand command, callback
      plugin.__loaded = true
      return true
    else
      return false


  unload: (name) ->
    if plugin = @plugins[name]
      return false if plugin.__prevent_unload
      if plugin.teardown
        plugin.teardown() 
      if @bot.missingCommandHandler == plugin.__missingCommandHandler
        @bot.removeMissingCommandHandler()
      for event, callbacks of plugin.__listeners
        for callback in callbacks
          @bot.removeListener event, callback
      for command, callback of plugin.__commands
        @bot.removeCommand command, callback
      plugin.__loaded = false
      return true
    else
      return false

  get: (name) ->
    @plugins[name]

  getAllNames: () ->
    Object.keys @plugins

  getAllLoadedNames: () ->
    Object.keys((name for name, plugin of plugins when plugin.__loaded))

  __unloadAll: ->
    for name in @getAllLoadedNames()
      @unload(name)

  __scan: ->
    files = fs.readdirSync(path.join(__dirname, 'plugins'))
    for file in files
      plugin = new(require("./plugins/#{file}"))(@bot, @config)
      pluginName = plugin.__name
      @plugins[pluginName] = plugin
      plugin.__loaded = false
      if plugin.__autoload
        @load pluginName

module.exports = PluginManager