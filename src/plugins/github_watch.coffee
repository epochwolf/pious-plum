GitHubApi = require "node-github"

prefix = "GitHub |"
repo_url = /\/?([^\/]+)\/([^\/?]+)/
issues_url = /\/?([^\/]+)\/([^\/]+)\/issues\/(\d+)/
commits_url = /\/?([^\/]+)\/([^\/]+)\/commit\/([^\/?]+)/

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
    @rate_limiter = new(require('../rate_limiter'))(10 * 60)

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
    {path} = url

    if match = path.match issues_url
      [_, user, repo, issue_id]  = match
      @conn().issues.getRepoIssue {user: user, repo: repo, number: issue_id}, (err, data) =>
        if err
          @bot.say channel, "#{prefix} Error: #{err}"
        else
          {title, number, state} = data
          labels = data.labels.map((label) -> label.name).join(", ")
          login = data.user?.login
          @bot.say channel, "#{prefix} ##{number} (#{state}): #{title} [#{labels}]"


    else if match = path.match commits_url
      [_, user, repo, sha]  = match
      console.log match
      @conn().repos.getCommit {user:user, repo:repo, sha:sha}, (err, data) =>
        if err
          @bot.say channel, "#{prefix} Error: #{err}"
        else
          author = data.commit.author.name
          file_count = data.files.length
          {message} = data.commit
          {total, additions, deletions} = data.stats
          @bot.say channel, "#{prefix} #{author} (#{file_count} files: +#{additions} -#{deletions}) : #{message}"

    else if match = path.match repo_url
      [_, user, repo] = match

      unless @rate_limiter.okay "#{user}/#{repo}"
        return

      @conn().repos.get {user: user, repo:repo}, (err, data)=>
        if err
          @bot.say channel, "#{prefix} Error: #{err}"
        else
          {name, full_name, description, open_issues, homepage, has_issues, has_wiki} = data
          forks = data.forks_count
          stars = data.watchers_count
          @bot.say channel, "#{prefix} #{full_name} (#{stars}★ #{forks}♆ #{open_issues}☤) : #{description}"

  linkToGithub: (channel, who, args) => 
    [user, repo] = args
    @conn().repos.get {user: user, repo:repo}, (err, data)=>
      if err
        @bot.say channel, "#{prefix} Error: #{err}"
      else
        {name, full_name, description, open_issues, homepage, has_issues, has_wiki} = data
        forks = data.forks_count
        stars = data.watchers_count
        @bot.say channel, "#{prefix} https://github.com/#{user}/#{repo} (#{stars}★ #{forks}♆ #{open_issues}☤) : #{description}"

module.exports = Plugin