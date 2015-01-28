
# Enable debug
db = require('debug')
db.enable('*')
debug = db('gitbook-assets:entry')

# Startup
hljs = require('highlight.js')

debug('invoking initHighlightingOnLoad')
hljs.initHighlightingOnLoad()
 
debug('Adding css')
require('./solarized_light.css')

debug('Hook up hljs')
$('pre code').addClass('hljs')