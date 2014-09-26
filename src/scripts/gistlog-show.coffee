# Description
#   A Hubot script that DESCRIPTION
#
# Configuration:
#   None
#
# Commands:
#   hubot gistlog show [<username>] <date> - show a gistlog entry
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  DEFAULT_USERNAME = process.env.HUBOT_GISTLOG_SHOW_USERNAME

  getJson = (res, url, cb) ->
    res.http(url).get() (err, _, body) ->
      if err? then cb(err, null) else cb(null, JSON.parse(body))

  getList = (res, username, cb) ->
    url = "https://api.github.com/users/#{username}/gists"
    getJson(res, url, cb)

  getEntry = (res, gist, cb) ->
    getJson(res, gist.url, cb)

  robot.respond /gistlog show (\S+)(?: (\S+))?$/i, (res) ->
    arg1 = res.match[1]
    arg2 = res.match[2]
    username = if arg2 then arg1 else DEFAULT_USERNAME
    date = if arg2 then arg2 else arg1

    getList res, username, (err, gists) ->
      return res.send(err) if err?
      pattern = new RegExp('^' + date)
      gist = gists.filter((gist) -> pattern.test(gist.description))[0]
      return res.send('no entry') unless gist?

      getEntry res, gist, (err, gist) ->
        return res.send(err) if err?
        title = gist.description
        content = gist.files[Object.keys(gist.files)[0]].content

        res.send """
          #{title}
          #{content}
          """
