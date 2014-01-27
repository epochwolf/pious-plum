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


url_regex = /(https?):\/\/(?:www\.)?([-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6})(?:\:(\d{2,6}))?\b([-a-zA-Z0-9@:%_\+.~#&\/\/=]*)\??([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/

UrlDetector = 
  has_url: (string)->
    if match = string.match(url_regex)
      url:      match[0]
      protocol: match[1]
      host:     match[2]
      port:     match[3] || (if match[1] == "https" then "443" else "80" ) 
      path:     match[4]
      query:    match[5]
    else
      false


module.exports = UrlDetector
