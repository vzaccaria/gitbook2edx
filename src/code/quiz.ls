_ = require('lodash')

# Quiz section shoul be an object:
#
# From:
#
# { id: 'gitbook_31',
#  type: 'exercise',
#  content: '<p>Questo è un quiz</p>\n',
#  lang: 'quiz',
#  code:
#   { base: 'Pippo\nPluto\nPaperino',
#     solution: 'Pippo',
#     validation: 'Feedback',
#     context: null },
#  urlName: 'oc9hcjxl' }
#
#
# id: 'gitbook_73',
# type: 'normal',
# content: '<h1 id="length">Length</h1>\n<p>It&#39;s easy in Javascript to know how many characters are in string using the property <code>.length</code>.</p>\n<pre><code class="lang-js"><span class="hljs-comment">// Just use the property .length</span>\n<span class="hljs-keyword">var</span> size = <span class="hljs-string">\'Our lovely string\'</span>.length;\n</code></pre>\n<p><strong>Note:</strong> Strings can not be substracted, multiplied or divided.</p>\n',
# urlName: '8uraws1b' }





module.exports = (section) ->
  # delete section.code
  # delete section.lang
  # section.type = 'normal'
  return section
