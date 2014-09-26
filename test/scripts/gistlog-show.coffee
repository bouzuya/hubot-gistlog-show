{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'gistlog-show', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot gistlog show bouzuya 2014-09-26'
          matches: [
            '@hubot gistlog show bouzuya 2014-09-26'
            'bouzuya'
            '2014-09-26'
          ]
        ,
          message: '@hubot gistlog show 2014-09-26'
          matches: [
            '@hubot gistlog show 2014-09-26'
            '2014-09-26'
            undefined
          ]
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot gistlog show bouzuya 2014-09-26"', ->
      beforeEach ->
        @send = @sinon.spy()
        @hello
          send: @send


    describe 'receive "@hubot hello"', ->
      beforeEach ->
        responseBody1 = [
          description: '2014-09-26 title'
        ]
        responseBody2 =
          description: '2014-09-26 title'
          files:
            'index.md':
              content: 'body'
        httpGetResponse = @sinon.stub()
        httpGetResponse
          .onFirstCall()
          .callsArgWith 0, null, null, JSON.stringify(responseBody1)
        httpGetResponse
          .onSecondCall()
          .callsArgWith 0, null, null, JSON.stringify(responseBody2)
        httpGet = @sinon.stub()
        httpGet.onFirstCall().returns httpGetResponse
        httpGet.onSecondCall().returns httpGetResponse
        http = @sinon.stub()
        http.onFirstCall().returns get: httpGet
        http.onSecondCall().returns get: httpGet
        @send = @sinon.spy()
        @hello
          match: [
            '@hubot gistlog show bouzuya 2014-09-26'
            'bouzuya'
            '2014-09-26'
          ]
          send: @send
          http: http

      it 'send "2014-09-26 title\\nbody"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is '''
          2014-09-26 title
          body
        '''

  describe 'robot.helpCommands()', ->
    it '''
should be ["hubot gistlog show [<username>] <date> - show a gistlog entry"]
       ''', ->
      assert.deepEqual @robot.helpCommands(), [
        'hubot gistlog show [<username>] <date> - show a gistlog entry'
      ]
