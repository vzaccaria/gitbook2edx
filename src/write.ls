
shelljs = require('shelljs')
bluebird = require('bluebird')
debug = require('debug')(__filename)
path = require('path')

_module = ->

    write = (data) ->
        { metadata, files } = data
        bluebird.props(files).then (data) ->
            debug('Removing ./_course')
            shelljs.rm('-rf', './_course')
            shelljs.rm('-f','./course.tar.gz')

            shelljs.mkdir('-p', './_course')
            shelljs.mkdir('-p', './_course/static')

            for k,v of files
              if v?
                shelljs.mkdir('-p', "./_course/#{path.dirname(k)}")

            shelljs.cp("#{__dirname}/../static/*", "./_course/static")

            for k,v of data
              if v?
                debug("Writing #k")
                v.to("./_course/#k")
              else
                debug("Somethings wrong with #{k}, it seems that I was not able to build the file.")

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
