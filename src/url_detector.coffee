# > m = " http://github.com/benprew/pony?2 ".match(/(https?):\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*)?(\?\S+)?)?/);
# [ 'http://github.com/benprew/pony?2',
#   'http',
#   'github.com',
#   undefined,
#   '/benprew/pony?2',
#   'benprew/pony',
#   '?2',
#   index: 1,
#   input: ' http://github.com/benprew/pony?2 ' ]


url_regex = /(https?):\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\-\.]*)?(\?\S+)?)?/

UrlDetector = 
  has_url: (string)->
    if match = string.match(url_regex)
      url:      match[0]
      protocol: match[1]
      host:     match[2]
      port:     match[3] || "80"
      path:     "/#{match[5]}"
      query:    match[6]
    else
      false


module.exports = UrlDetector