// A bot to rule the world!

// Setup a signal trap
process.stdin.resume();
process.on('SIGINT', function() {
  bot.disconnect(process.exit);
});


var irc = require("irc");
var config = require('./config');

console.log("Stating bot");
var bot = new irc.Client(config.server, config.botName, {
  channels: config.channels
});

bot.addListener("join", function(channel, who) {
  console.log("")
  if(who != config.nick){
    bot.say(channel, who + ": hi!");
  }
});
