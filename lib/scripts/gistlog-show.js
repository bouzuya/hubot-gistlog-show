// Description
//   A Hubot script that DESCRIPTION
//
// Configuration:
//   None
//
// Commands:
//   hubot gistlog show [<username>] <date> - show a gistlog entry
//
// Author:
//   bouzuya <m@bouzuya.net>
//
module.exports = function(robot) {
  var DEFAULT_USERNAME, getEntry, getJson, getList;
  DEFAULT_USERNAME = process.env.HUBOT_GISTLOG_SHOW_USERNAME;
  getJson = function(res, url, cb) {
    return res.http(url).get()(function(err, _, body) {
      if (err != null) {
        return cb(err, null);
      } else {
        return cb(null, JSON.parse(body));
      }
    });
  };
  getList = function(res, username, cb) {
    var url;
    url = "https://api.github.com/users/" + username + "/gists";
    return getJson(res, url, cb);
  };
  getEntry = function(res, gist, cb) {
    return getJson(res, gist.url, cb);
  };
  return robot.respond(/gistlog show (\S+)(?: (\S+))?$/i, function(res) {
    var arg1, arg2, date, username;
    arg1 = res.match[1];
    arg2 = res.match[2];
    username = arg2 ? arg1 : DEFAULT_USERNAME;
    date = arg2 ? arg2 : arg1;
    return getList(res, username, function(err, gists) {
      var gist, pattern;
      if (err != null) {
        return res.send(err);
      }
      pattern = new RegExp('^' + date);
      gist = gists.filter(function(gist) {
        return pattern.test(gist.description);
      })[0];
      if (gist == null) {
        return res.send('no entry');
      }
      return getEntry(res, gist, function(err, gist) {
        var content, title;
        if (err != null) {
          return res.send(err);
        }
        title = gist.description;
        content = gist.files[Object.keys(gist.files)[0]].content;
        return res.send("" + title + "\n" + content);
      });
    });
  });
};
