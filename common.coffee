fs = require 'fs'
request = require 'request'

request('https://www.cloudflare.com/ips-v4').pipe fs.createWriteStream('./common/cloudflare.ip4')
