pious-plum
==========

An irc bot in Node.js


But what does it do?
--------------------

The primary purpose of the bot is to retrieve information when a url is mentioned in a channel. Right now the bot supports github, twitter, and youtube. 

* github.com
  * Repository Information
  * Commit Information
  * Issue Information
* twitter.com
  * Displays tweets. 
* youtube.com/youtu.be
  * Displays video title and length

Examples
--------

**Youtube**

    <epochwolf> https://www.youtube.com/watch?v=HU2ftCitvyQ&feature=youtu.be
    <prettyinpurple> YouTube | Shatner Of The Mount by Fall On Your Sword | 2:33

**Twitter**

    <epochwolf> https://twitter.com/jeromejtk/status/365112147421831170
    <prettyinpurple> Twitter | Jeremy Knope (@jeromejtk) at 7:08 - 7 Aug 13: Wonder if I leave this banana peel near my keyboard it'll keep the cat from getting near it

**Github**

    <epochwolf> https://github.com/epochwolf/pious-plum
    <prettyinpurple> GitHub | epochwolf/pious-plum (1★ 0♆ 0☤) : An irc bot in Node.js

    <epochwolf> https://github.com/epochwolf/litsocial/issues/24
    <prettyinpurple> GitHub | #24 (open): Add google analytics [Feature]

    <epochwolf> https://github.com/epochwolf/epochwolf.com/commit/71afbb61fca85a8f07965894e64cb40ceefa1568
    <prettyinpurple> GitHub | epochwolf (2 files: +30 -1) : The donate button is back. Y'all freaking happy?