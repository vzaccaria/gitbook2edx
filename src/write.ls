
shelljs = require('shelljs')
bluebird = require('bluebird')
debug = require('debug')(__filename)

_module = ->

    write = (data) ->
        { metadata, files } = data
        bluebird.props(files).then (data) -> 
            debug('Removing ./_course')
            shelljs.rm('-rf', './_course')
            shelljs.rm('-f','./course.tar.gz')

            shelljs.mkdir('-p', './_course')
            shelljs.mkdir('-p', './_course/about')
            shelljs.mkdir('-p', './_course/static')

            shelljs.cp("#{__dirname}/../static/*", "./_course/static")

            for k,v of data
                debug("Writing #k")
                v.to("./_course/#k")

            new bluebird (resolve, rej) ->
                debug 'Packing up with `tar cvzf course.tar.gz _course`'
                shelljs.exec 'tar cvzf course.tar.gz _course', { +async }, (code, output) ->
                    if code 
                        rej('sorry, command failed')
                    else
                        resolve('ok')

    return {
        write: write
    }



module.exports = _module()