#!/usr/bin/env coffee
expect = require('chai').expect
Module = require '..'

describe 'Module API', ->
  it 'should load/exist', ->
    expect(Module).to.exist

describe 'Initializing tests', ->
  it 'should load from an array', ->
    foo = Module(['192.168.0.0/24', '127.0.0.1'])
    expect(foo).to.exist
    expect(foo).to.be.a('function')

  it 'should load from a file', ->
    foo = Module('./test/whitelist.txt')
    expect(foo).to.exist
    expect(foo).to.be.a('function')

  it 'should load from common', ->
    foo = Module('common/cloudflare')
    expect(foo).to.exist
    expect(foo).to.be.a('function')

describe 'Middleware tests', ->
  before (done) ->
    global.foo = Module(['192.168.0.0/24', '127.0.0.1'])
    setTimeout done, 1000

  it 'should match 127.0.0.1', (done) ->
    global.foo {ip: '127.0.0.1'}, null, (err) ->
      expect(err).to.be.undefined
      done()

  it 'should NOT match 127.0.0.2', (done) ->
    global.foo {ip: '127.0.0.2'}, null, (err) ->
      expect(err).to.be.an.instanceof(Error)
      expect(err.name).to.equal('WhitelistIpError')
      done()

  it 'should match 192.168.0.200', (done) ->
    global.foo {ip: '192.168.0.200'}, null, (err) ->
      expect(err).to.be.undefined
      done()

  it 'should NOT match 43.21.83.90', (done) ->
    global.foo {ip: '43.21.83.90'}, null, (err) ->
      expect(err).to.be.an.instanceof(Error)
      expect(err.name).to.equal('WhitelistIpError')
      done()
