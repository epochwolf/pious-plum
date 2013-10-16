
class RateLimiter
  constructor: (@expiry=10*60)->
    @data = {}

  okay: (key)=> 
    check_time = Math.round(new Date().getTime() / 1000)
    @clearExpiredKeys(check_time) # Calling here so we don't leak ram by holding expired keys forever
    check = @data[key]

    if @data[key]
      return false 
    else 
      @data[key] = check_time + @expiry
      return true
    

  clearExpiredKeys: (check_time)=>
    for key, time of @data
      if time < check_time
        #console.log "removing #{key} since #{time} < #{check_time}"
        delete @data[key] 

module.exports = RateLimiter
