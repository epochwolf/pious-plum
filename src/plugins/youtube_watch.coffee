TwitterApi = require "ntwitter"
dateFormat = require('dateformat');

class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "youtube_watch"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      "message_with_url:www.youtube.com": [@videoDetailsLong],
      "message_with_url:youtube.com": [@videoDetailsLong],
      "message_with_url:youtu.be": [@videoDetailsShort]
    @__commands = {}
    @__autoload = true
    @youtube = require('youtube-feeds')

  conn: () ->
    @youtube

  setup: () =>
    console.log "youtube_watch plugin loaded"

  teardown:() =>
    console.log "youtube_watch plugin unloaded"

  videoDetailsLong: (channel, who, message, url) =>
    {path, query} = url
    # https://www.youtube.com/watch?v=HU2ftCitvyQ
    if path.match(/^\/watch/) && (match = query.match /v=([A-Za-z0-9_-]+)/)
      [_, video_id] = match
      console.log video_id
      @videoDetails channel, who, message, video_id

  videoDetailsShort: (channel, who, message, url) =>
    {path} = url
    # http://youtu.be/HU2ftCitvyQ
    if match = path.match /\/?([A-Za-z0-9_-]+)/
      [_, video_id] = match
      @videoDetails channel, who, message, video_id

  videoDetails: (channel, who, message, video_id) => 
    @conn().video video_id, (err, data ) =>
      if err
        console.log err
      else
        console.log data
        {title, duration} = data

        hours = parseInt( duration / 3600 ) % 24;
        minutes = parseInt( duration / 60 ) % 60;
        seconds = duration % 60;

        video_length = (if hours && minutes < 10 then "0" + minutes else minutes) + ":" + (if seconds < 10 then "0" + seconds else seconds)
        if hours
          video_length = hours + ":" + video_length

        @bot.say channel, "YouTube | #{title} | #{video_length}"


module.exports = Plugin