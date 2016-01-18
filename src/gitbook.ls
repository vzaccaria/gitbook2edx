shelljs = require('shelljs')
bluebird = require('bluebird')
debug = require('debug')(__filename)

_module = ->

    gitbook = (directory) ->

        debug "Removing #directory/_book"
        shelljs.rm('-rf', "#directory/_book")
        new bluebird (resolve, rej) ->
            cmd = "#{__dirname}/../node_modules/.bin/gitbook build -f json #directory"
            debug cmd
            shelljs.exec cmd, { +async, +silent }, (code, output) ->
                if code
                    debug("Error, #output")
                    rej("sorry, command #cmd failed with #code, output #output")
                else
                    debug("Ok")
                    resolve('ok')

    return {
        gitbook: gitbook
    }



module.exports = _module()
