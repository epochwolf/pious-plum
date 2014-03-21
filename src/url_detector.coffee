URL = require 'url'
url_regex = /https?:\/\/[^\s]+/

# Attempt to parse a possible url, if it fails, return undefined.
parse_url = (possible_url) ->
  try
    URL.parse(possible_url)
  catch e
    if not e instanceof ReferenceError
      throw e

UrlDetector =
  has_url: (string) ->
    if match = string.match url_regex
      parse_url(match[0])

module.exports = UrlDetector
