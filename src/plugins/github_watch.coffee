GitHubApi = require "node-github"


repo_url = /\/?([^\/]+)\/([^\/]+)/
issues_url = /\/?([^\/]+)\/([^\/]+)\/issues\/(\d+)/

class Plugin 
  constructor: (@bot, @config) -> 
    @__name = "github_watch"
    @__author = "epochwolf"
    @__version = "v0.0.1"
    @__listeners = 
      "message_with_url:github.com": [@githubDetails]
    @__commands = 
      gh: @linkToGithub
    @__autoload = true

  # Create new connection each time since there seems to be a caching issue inside node-github
  conn: () ->
    github = new GitHubApi version: "3.0.0", timeout: 5000
    github.authenticate(@config.github_auth) if @config.github_auth
    github


  setup: () =>
    console.log "github_watch plugin loaded"

  teardown:() =>
    console.log "github_watch plugin unloaded"


  githubDetails: (channel, who, message, url) =>
    #match = null
    {path} = url
    console.log "Github link: #{path}"
    if match = path.match issues_url
      [_, user, repo, issue_id]  = match
      @conn().issues.getRepoIssue {user: user, repo: repo, number: issue_id}, (err, data) =>
        if err
          @bot.say channel, "Hmmm... github didn't like that: #{err}"
        else
          console.log data
          {title, number, state} = data
          labels = data.labels.map((label) -> label.name).join(", ")
          login = data.user?.login
          @bot.say channel, "##{number} (#{state}): #{title} [#{labels}]"
    else if match = path.match repo_url
      [_, user, repo] = match
      @conn().repos.get {user: user, repo:repo}, (err, data)=>
        if err
          @bot.say channel, "Hmmm... github didn't like that: #{err}"
        else
          console.log data
          {name, full_name, description, open_issues, homepage, has_issues, has_wiki} = data
          forks = data.forks_count
          stars = data.watchers_count
          @bot.say channel, "#{full_name} (#{stars}★ #{forks}♆ #{open_issues}☤) : #{description}"

  linkToGithub: (channel, who, args) => 
    [username, project] = args
    @bot.say channel, "https://github.com/#{username}/#{project}"

module.exports = Plugin