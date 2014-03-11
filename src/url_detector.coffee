URL = require 'url'
url_regex = /https?:\/\/[^\s]+/

rewrite_url = (url) ->
  url: url.href
  protocol: url.protocol.replace(':', '')
  host: url.hostname
  port: url.port or (url.protocol is 'http:' and "80" or "443")
  path: url.pathname
  query: url.search

UrlDetector =
  has_url: (string) ->
    match = string.match url_regex
    match && rewrite_url(url.parse(match[0])) || false

module.exports = UrlDetector
