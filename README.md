# whitelist-ips
Connect/Express middleware for whitelisting by IP addresses.

Pretty simple really. Example:

```Javascript
var express = require('express');
var whitelist = require('./index');

var app = express();
// Use one of the built-in lists. So far it's just Cloudflare. (https://www.cloudflare.com/ips-v4 and ips-v6)
app.use(whitelist('common/cloudflare'));
// OR
// Pass an array of IP addresses
app.use(whitelist( ['127.0.0.1', '192.168.0.0/24'] ));
// OR
// Pass a filename
app.use(whitelist('whitelist.txt'));

app.get('/', function (req, res) {
  res.send('Hello '+req.ip+'!');
});
app.use(function (err, req, res, next) {
    if (err.name == "WhitelistIpError") {
        res.status(403).send('Forbidden');
    } else {
        res.status(404).send('Not Found');
    }
});

var server = app.listen(8080);
```

Requests that come from addresses outside of the whitelist generate an error
that you can handle with Express's middleware error handling facilities.
