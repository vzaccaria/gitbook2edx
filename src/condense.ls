glob     = require('glob')
fs       = require('fs')
bluebird = require('bluebird')
_        = require('lodash')
debug    = require('debug')(__filename)
uid      = require('uid')
b64 = require('base64-url')
bluebird.promisifyAll(fs)

y = require('js-yaml')

$ = require('underscore.string')

escape-section = (d, name) ->
    if d.code?[name]?
        d.code[name] = _.escape(d.code[name])


escape-code-sections = (data) ->
    for d in data.sections
        d.url-name = uid(8)
        if d.code?
            d.code.lang = d.lang
            d.grader_payload = {
                payload: b64.encode(JSON.stringify(d.code))
            }
            d.grader_payload = JSON.stringify(d.grader_payload)
            escape-section(d, 'base')
            escape-section(d, 'solution')
    return data


_module = ->

    condense = (directory, source-dir, config) ->
        metadata = y.safeLoad(fs.readFileSync(config, 'utf-8'))

        metadata.course.orig-dir = source-dir
        metadata.course.displayName = metadata.course.name
        metadata.course.name = $.slugify( metadata.course.number )

        metadata.organization.displayName = metadata.organization.name
        metadata.organization.name = $.slugify(metadata.organization.name)

        files = glob.sync("#directory/**/*.json")
        promised_files = [ fs.readFileAsync(f, 'utf-8') for f in files ]

        bluebird.all(promised_files).map ->
            data = JSON.parse(it)
            level = data.progress.current.level
            matches = (level == /(\d)+.?(\d)*/)
            if matches
                sequential = {
                    chapter: parseInt(matches[1])
                    title: data.progress.current.title
                    verticals: escape-code-sections(data).sections
                }
                sequential.section = parseInt(matches[2]) if matches[2]?
                sequential.section ?= 0

                sequential.displayName = sequential.title
                sequential.name = $.slugify(sequential.displayName)
                sequential.urlName = sequential.name+"-#{uid(8)}"
                return sequential 
            else 
                return undefined
        .then ->
            grouped = _.groupBy(it, 'chapter')
            grouped = [ v for k,v of grouped ]
            grouped = [ _.sortBy(v, 'section') for v in grouped ]


            grouped = _.map grouped, ->
                it.displayName = it[0].displayName
                it.urlName = "#{it[0].urlName}-#{uid(8)}"
                return it

            debug("All data gathered into a single structure")

            return _.extend(metadata, { chapters: grouped })

    return {
        condense: condense
    }

module.exports = _module()



