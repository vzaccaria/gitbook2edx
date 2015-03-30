_  = require('lodash')
promise = require('bluebird')
var plugins

plugins := {
}

register-plugin = (name, func) ->
  plugins[name] = func

process-code = (d) ->
  return new promise (resolve, reject) ->
    if d.lang? && (d.lang in _.keys(plugins))
      resolve(plugins[d.lang](d))
    else
      d.exercise = true
      resolve(d)




register-plugin('quiz', require('./quiz'))

module.exports = {
  process-code
  register-plugin
}
