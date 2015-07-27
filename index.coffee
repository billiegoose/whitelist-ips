fs = require 'fs'
ipRangeCheck = require 'ip-range-check'

WhitelistIpError = (message) ->
  e = new Error
  e.name = "WhitelistIpError"
  e.message = message
  return e

class Whitelist
  @ranges = []
  constructor: (init) ->
    if init instanceof Array
      @loadFromArray init
    else if (typeof init is "string")
      if /^common/.test(init)
        @loadFromFile __dirname + '/' + init
      else
        @loadFromFile init
    else
      throw Error "whitelist-ips Error: Unrecognized argument type #{typeof init}"

  loadFromArray: (lines) ->
    @ranges = (line.trim() for line in lines when line.trim() != '')

  loadFromFile: (path) ->
    fs.readFile path, 'utf8', (err, data) =>
      return console.warn "whitelist-ips Error: ", err if err?
      @loadFromArray data.split('\n')

  middleware: (req, res, next) ->
    ip = req.ip
    if ipRangeCheck ip, @ranges
      return next()
    else
      return next WhitelistIpError "IP #{ip} not in whitelist"

  # For debugging/testing purposes
  test: (list) ->
    for ip in list
      @middleware {ip: ip}, null, (err) =>
        return console.log "#{ip} Failed" if err?
        console.log "#{ip} Passed"

module.exports = (init) ->
  wl = new Whitelist(init)
  return wl.middleware.bind(wl)
