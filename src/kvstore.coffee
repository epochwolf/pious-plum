fs = require 'fs'
path = require 'path'

class KVStore
  constructor: (@filename)->
    @store = require(@filename)

  get: (key)-> 
    console.log "KV #{key}"
    @store[key] 

  set: (key, value)-> 
    console.log "KV #{key} = #{value}"
    @store[key] = value
    @flush()

  flush: ->
    fs.writeFileSync @filename, JSON.stringify @store

module.exports = KVStore