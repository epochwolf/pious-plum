TwitterApi = require "ntwitter"
dateFormat = require('dateformat');

# twitter.com/fxn/status/343353320783634432
tweet_url = /\/?([^\/]+)\/status\/([^\/?]+)/

class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "twitter_watch"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      "message_with_url:twitter.com": [@tweetDetails]
    @__commands = {}
    @__autoload = true

  # Create new connection each time since there seems to be a caching issue inside node-github
  conn: () ->
    new TwitterApi @config.twitter_auth

  setup: () =>
    console.log "twitter_watch plugin loaded"

  teardown:() =>
    console.log "twitter_watch plugin unloaded"

  tweetDetails: (channel, who, message, url) =>
    {path} = url
    console.log "Tweet link: #{path}"
    if match = path.match tweet_url
      [_, user, tweet_id] = match
      @conn().getStatus tweet_id, (err, data) =>
        if err
          console.log err
        else
          console.log data

          {text, user, favorite_count, retweet_count, created_at} = data
          date = new Date created_at
          date = dateFormat date, "h:MM - d mmm yy"
          text = text.replace /[\n\r]/mg, " "

          # Twitter | Randy Luecke (@me1000) at 10:52 AM - 8 Jun 13: My #wwdctip: bring a schwag bag. People will be handing out clothes, stickers, and other goodies. I may even have some BugHub stickers ;)
          @bot.say channel, "Twitter | #{user.name} (@#{user.screen_name}) at #{date}: #{text} "


module.exports = Plugin