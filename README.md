# hubot-gistlog-show

A Hubot script that shows a gistlog entry

![](http://img.f.hatena.ne.jp/images/fotolife/b/bouzuya/20140926/20140926224619.gif)

## Installation

    $ npm install git://github.com/bouzuya/hubot-gistlog-show.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-gistlog-show.git#TAG'

## Example

    bouzuya> hubot help gistlog show
      hubot> hubot gistlog show [<username>] <date> - show a gistlog entry

    bouzuya> hubot gistlog show 2014-09-26
      Hubot> 2014-09-26 blog の要件
             blog が blog であるために必要なものは何だろう。

             とりあえず条件をあげてみよう。

             - article を見られる。
             - article の一覧を見られる。
             - それぞれの article が permalink を持つ。
             - それぞれの article が tags を持つ。
             - それぞれの article が pubdate を持つ。
             - article の関連する article を見られる。
             - article の前後の article を見られる。
             - article を投稿できる。
             - feed を見られる。

             投稿できて、それを整理できれば良いと。Gist でやろうとすると問題になるのは整理だなあ。

## Configuration

See [`src/scripts/gistlog-show.coffee`](src/scripts/gistlog-show.coffee).

## Development

`npm run`

## License

[MIT](LICENSE)

## Author

[bouzuya][user] &lt;[m@bouzuya.net][mail]&gt; ([http://bouzuya.net][url])

## Badges

[![Build Status][travis-badge]][travis]
[![Dependencies status][david-dm-badge]][david-dm]
[![Coverage Status][coveralls-badge]][coveralls]

[travis]: https://travis-ci.org/bouzuya/hubot-gistlog-show
[travis-badge]: https://travis-ci.org/bouzuya/hubot-gistlog-show.svg?branch=master
[david-dm]: https://david-dm.org/bouzuya/hubot-gistlog-show
[david-dm-badge]: https://david-dm.org/bouzuya/hubot-gistlog-show.png
[coveralls]: https://coveralls.io/r/bouzuya/hubot-gistlog-show
[coveralls-badge]: https://img.shields.io/coveralls/bouzuya/hubot-gistlog-show.svg
[user]: https://github.com/bouzuya
[mail]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
