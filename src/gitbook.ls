shelljs = require('shelljs')
bluebird = require('bluebird')
debug = require('debug')(__filename)

_module = ->

    gitbook = (directory) ->

        debug "Removing #directory/_book"
        shelljs.rm('-rf', "#directory/_book")
        new bluebird (resolve, rej) ->
            debug "gitbook build -f json #directory"
            shelljs.exec "gitbook build -f json #directory", { +async, +silent }, (code, output) ->
                if code 
                    debug("Error, #output")
                    rej('sorry, command failed')
                else
                    debug("Ok")
                    resolve('ok')

    return {
        gitbook: gitbook 
    }



module.exports = _module()