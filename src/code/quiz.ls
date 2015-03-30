_ = require('lodash')
Liquid = require("liquid-node")
engine = new Liquid.Engine
fs = require('fs')
debug = require('debug')(__filename)

text = fs.readFileSync(__dirname+'/../../template/quiz.xml', 'utf-8')
template = engine.parse(text)

module.exports = (section) ->
  return template.then (t) ->
    section.question = section.content
    section.choices = section.code.base.split('\n')
    section.solutions = section.code.solution.split('\n')
    section.feedback = section.code.validation
    section.items = _.map section.choices, ->
      { text: it, correct: (it in section.solutions) }
    return t.render(section).then (rendered) ->
      section.type = "plugin"
      section.content = rendered
      delete section.code
      delete section.lang
      section.exercise = true
      return section

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
