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
    @url.url

  get_library: =>
    console.log @url
    if @url.protocol == "https"
      console.log 'https'
      require('follow-redirects').https
    else
      console.log 'http'
      require('follow-redirects').http

module.exports = UrlFetcher
