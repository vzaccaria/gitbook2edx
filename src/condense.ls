glob     = require('glob')
fs       = require('fs')
bluebird = require('bluebird')
_        = require('lodash')

bluebird.promisifyAll(fs)

y = require('js-yaml')

$ = require('underscore.string')

_module = ->

    condense = (directory, config) ->
        metadata = y.safeLoad(fs.readFileSync(config, 'utf-8'))

        metadata.course.displayName = metadata.course.name
        metadata.course.name = $.slugify( metadata.course.displayName )

        metadata.organization.displayName = metadata.organization.name
        metadata.organization.name = $.slugify(metadata.organization.name)

        files = glob.sync("#directory/**/*.json")
        promised_files = [ fs.readFileAsync(f, 'utf-8') for f in files ]
        bluebird.all(promised_files).map ->
            data = JSON.parse(it)
            level = data.progress.current.level
            matches = (level == /(\d)+.?(\d)*/)
            if matches
                ret = {
                    chapter: parseInt(matches[1])
                    title: data.progress.current.title
                    content: data.sections
                }
                ret.section = parseInt(matches[2]) if matches[2]?
                ret.section ?= 0

                ret.displayName = ret.title
                ret.name = $.slugify(ret.displayName)
                ret.urlName = ret.name
                return ret
            else 
                return undefined
        .then ->
            grouped = _.groupBy(it, 'chapter')
            grouped = [ v for k,v of grouped ]
            grouped = [ _.sortBy(v, 'section') for v in grouped ]

            grouped = _.map grouped, ->
                it.displayName = it[0].displayName
                it.urlName = it[0].urlName
                return it

            return _.extend(metadata, { chapters: grouped })

    return {
        condense: condense
    }

module.exports = _module()



