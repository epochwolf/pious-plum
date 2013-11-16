GitHubApi = require "node-github"

url_regex = /(https?):\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\-\.]*)?(\?\S+)?)?/


class UrlFetcher
  # Expects url to be from url_detector
  constructor: (url) ->
    @url = url
    @data = {}

  handle: (func) => 
    http = @get_library()
    http.request(@get_real_url(), func)

  get_real_url: => 
    @url

  get_library: =>
    if @url.protocol == "https"
      require('https')
    else
      require('http')

module.exports = UrlFetcher