Netmask = require('netmask').Netmask
fs = require 'fs'
#request = require 'request'

class Whitelist
  @masks = []
  constructor: (init) ->
    if init instanceof Array
      @loadFromArray init
#    else if (typeof init is "string") && /^http/.test init
#      @loadFromUrl init
    else if (typeof init is "string")
      @loadFromFile init
    else
      throw Error "whitelist-ips Error: Unrecognized argument type #{typeof init}"

  loadFromArray: (lines) ->
    lines = (line.trim() for line in lines when line.trim() != '')
    @masks = (new Netmask(line) for line in lines)

  loadFromFile: (path) ->
    fs.readFile path, 'utf8', (err, data) =>
      return console.warn "whitelist-ips Error: ", err if err?
      @loadFromArray data.split('\n')

#  loadFromUrl: (url) ->
#    request url, (err, response, body) =>
#      return console.warn "whitelist-ips Error: ", err if err?
#      @loadFromArray body.split('\n')

  middleware: (req, res, next) ->
    ip = req.ip
    for block in this.masks
      if block.contains ip
        return next()
    return next Error "IP #{ip} not in whitelist"

  # For debugging/testing purposes
  test: (list) ->
    for ip in list
      @middleware {ip: ip}, null, (err) =>
        return console.log "#{ip} Failed" if err?
        console.log "#{ip} Passed"

module.exports = (init) ->
  wl = new Whitelist(init)
  return wl.middleware.bind(wl)
