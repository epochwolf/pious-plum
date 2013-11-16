UrlFetcher = require '../url_fetcher'

ACCEPTABLE_MIMES = /(text|html|xml)/
TITLE_REGEX = /<title>(.*?)<\/title>/

STATUS_CODES =
  "200": "200 OK"
  "301": "301 Moved Permanently"
  "302": "302 Found"
  "307": "307 Temporary Redirect"
  "308": "308 Permanent Redirect"
  "401": "401 Unauthorized"
  "403": "403 Forbidden"
  "404": "404 Not Found"
  "405": "405 Method Not Allowed"
  "420": "420 Rate Limited"
  "422": "422 Unprocessable Entity"
  "500": "500 Internal Server Error"
  "502": "502 Bad Gateway"
  "503": "503 Service Unavailable"
  "504": "504 Gateway Timeout"
  "509": "509 Bandwidth Limit Exceeded"

bytesToSize = (bytes) -> 
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  if (bytes == 0) 
    return 'n/a'
  
  i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
  return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[[i]]


class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "url_watch"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      "message_with_url": [@urlDetails]
    @__commands = {}
    @__autoload = true
    @rate_limiter = new(require('../rate_limiter'))(30 * 60) # 30 minutes

  setup: () =>
    console.log "url_watch plugin loaded"

  teardown:() =>
    console.log "url_watch plugin unloaded"

  urlDetails: (channel, who, message, url) =>
    {url, host} = url

    unless @rate_limiter.okay url
      return

    request = new(UrlFetcher)(url).handle (res)=>
      status_code = res.statusCode
      content_type = res.headers['content-type']
      length = res.headers['content-length']
      data = ""

      res.on 'end', () =>
        display_status = STATUS_CODES["#{status_code}"] || status_code
        title = if "#{content_type}".match ACCEPTABLE_MIMES then "#{data}".match(TITLE_REGEX)[1]
        if title
          @bot.say channel, "Url | #{display_status} (#{content_type}) | #{title.replace(/&amp;/, "&")}"
        else if length
          @bot.say channel, "Url | #{display_status} (#{content_type}) | #{bytesToSize length}"
        else
          @bot.say channel, "Url | #{display_status} (#{content_type}) | unknown size"

      res.on 'data', (d) => 
        data += d
        if data.length > 400000 # We don't want to read all 4.7 gb of an iso if someone is being a dick.
          res.socket.end()

    request.end()
    request.on 'error', (e) =>
        console.error e

module.exports = Plugin