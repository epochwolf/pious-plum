fs = require 'fs'
path = require 'path'

class KVStore
  constructor: (filename)->
    @filename = path.join(process.cwd(), filename)
    @store = if fs.existsSync @filename then require @filename else {}

  get: (key)-> 
    @store[key] 

  set: (key, value)-> 
    if value == null
      delete @store[key]
    else
      @store[key] = value
    @flush()

  flush: ->
    fs.writeFileSync @filename, JSON.stringify @store

module.exports = KVStore