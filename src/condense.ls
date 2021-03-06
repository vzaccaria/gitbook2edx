glob      = require('glob')
fs        = require('fs')
promise   = require('bluebird')
_         = require('lodash')
debug     = require('debug')(__filename)
uid       = require('uid')
b64       = require('base64-url')
y         = require('js-yaml')
$         = require('underscore.string')
{ process-code } = require('./code/process-code')

moment    = require('moment')

parseTitle = (title, data) ->
  matches = (title == /[^\{]*\{([^\}]*)\}/)
  if matches
    debug(matches[1])
    var format

    values    = matches[1].split(',')

    exercises = _.reject(values, -> (it == /W(\d+)/)?)

    if data.grading?.GRADER?
      format := _.first(_.filter data.grading.GRADER, ->
        it.short_label == exercises[0])?.type

    graded = format?
    week = _.compact _.map values, ->
      m = (it == /W(\d+)/)
      if m
        return m[1]
      else
        null

    title = title.replace(/\s*\{[^\}]*\}/, '')
    start = week[0]
    return { graded, start, title, format }
  return { graded: false, title: title }

promise.promisifyAll(fs)

escape-section = (d, name) ->
    if d.code?[name]?
        d.code[name] = _.escape(d.code[name])

get-verticals = (data) ->
    return promise.map data.sections, (d) ->
        d.url-name = uid(8)
        /*d.content = d.content.replace(/\n/g, '&#xD;&#xA;')*/
        debug d.content

        return process-code(d).then (d) ->
          if d.code?
              d.code.lang = d.lang
              d.grader_payload = {
                  payload: b64.encode(JSON.stringify(d.code))
              }
              d.grader_payload = JSON.stringify(d.grader_payload)
              escape-section(d, 'base')
              escape-section(d, 'solution')
          return d

_module = ->

    condense = (directory, source-dir, config) ->
        metadata = y.safeLoad(fs.readFileSync(config, 'utf-8'))

        metadata.course.orig-dir = source-dir
        metadata.course.urlName = "#{metadata.course.year}-#{metadata.course.season}"
        metadata.course.displayName = metadata.course.name
        metadata.course.name = $.slugify( metadata.course.number )

        metadata.organization.displayName = metadata.organization.name
        metadata.organization.name = $.slugify(metadata.organization.name)

        files = glob.sync("#directory/**/*.json")
        promised_files = [ fs.readFileAsync(f, 'utf-8') for f in files ]

        promise.all(promised_files).map ->
            data = JSON.parse(it)
            level = data.progress.current.level
            matches = (level == /(\d)+.?(\d)*/)
            if matches
                return get-verticals(data).then (verticals) ->
                  sequential = {
                      chapter: parseInt(matches[1])
                      title: data.progress.current.title
                      verticals: verticals
                  }
                  sequential.section = parseInt(matches[2]) if matches[2]?
                  sequential.section ?= 0

                  { graded, title, start, format } = parseTitle(sequential.title, metadata)
                  sequential.title = title
                  sequential.start = moment(metadata.course.start).add(start, 'week').format("YYYY MM DD") if start?
                  sequential.format = format if format?
                  sequential.graded = graded
                  sequential.displayName = sequential.title
                  sequential.name = $.slugify(sequential.displayName)
                  sequential.urlName = sequential.name+"-#{uid(8)}"
                  debug sequential if start?
                  return sequential
            else
                return undefined
        .then ->
            grouped = _.groupBy(it, 'chapter')
            grouped = [ v for k,v of grouped ]
            grouped = [ _.sortBy(v, 'section') for v in grouped ]

            _.map _.filter(_.flatten(grouped), (.graded)), ->
              it.exercises = (_.countBy(it.verticals, (.exercise == true)))['true'] || 0
              return it

            metadata.exercises = _.mapValues _.groupBy(_.filter(_.flatten(grouped), (.graded)), (.format)), ->
                 _.reduce it, ((sum, n) ->
                   sum + n.exercises), 0

            if metadata.grading?.GRADER?
              for d in metadata.grading.GRADER
                if d.type in _.keys(metadata.exercises)
                    d.min_count = metadata.exercises[d.type]
                else
                   d.min_count = 0
                   d.drop_count = 0

            grouped = _.map grouped, ->
                it.displayName = it[0].displayName
                it.start = it[0].start
                it.urlName = "#{it[0].urlName}-#{uid(8)}"
                return it

            debug("All data gathered into a single structure")


            return _.extend(metadata, { chapters: grouped })

    return {
        condense: condense
    }

module.exports = _module()
