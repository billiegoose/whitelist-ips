fs = require 'fs'
ASQ = require 'asynquence-contrib'
request = require 'request'
require('asynquence-request')(ASQ, request)

ASQ()
.get('https://www.cloudflare.com/ips-v4')
.val (response, body) ->
  fs.writeFileSync __dirname + '/common/cloudflare', body + '\n'
.get('https://www.cloudflare.com/ips-v6')
.val (response, body) ->
  fs.appendFileSync __dirname + '/common/cloudflare', body + '\n'
