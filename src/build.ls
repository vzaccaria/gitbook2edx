
require! 'fs'
debug = require('debug')(__filename)
promise = require('bluebird')
marked = require('marked')

files = {
    '/course.xml': fs.readFileSync(__dirname+'/../template/course.xml', 'utf-8')
    '/about/overview.html': fs.readFileSync(__dirname+'/../template/overview.html', 'utf-8')
    '/about/short_description.html': fs.readFileSync(__dirname+'/../template/short_description.html', 'utf-8')
}

Liquid = require("liquid-node")
engine = new Liquid.Engine
datejs = require('moment')

engine.registerFilters {
    markdown: (input) ->
        if input?
            debug("Invoking markdown on #input")
            return marked(input)
        else
            return ""

    datejs: (input) ->
        if input?
            d = datejs(new Date(input)).toISOString()
            debug("Converted #input to #d")
            return d
        else
            ""
    }

_module = ->

    build = (data) ->
        output = {}
        for k,v of files
            output[k] := engine.parseAndRender(v, data)
        if data.grading?
          output["/policies/#{data.course.urlName}/grading_policy.json"] = promise.resolve(JSON.stringify(data.grading, 0, 4))
        return { metadata: data, files: output }

    return {
        build: build
    }


module.exports = _module()
