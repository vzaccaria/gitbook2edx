
require! 'fs'

course_xml = fs.readFileSync(__dirname+'/../template/course.xml', 'utf-8')

Liquid = require("liquid-node")
engine = new Liquid.Engine

_module = ->

    build = (data) ->
        console.log data
        engine.parseAndRender(course_xml, data)
        .then ->
            console.log it
        .caught -> 
            console.log it

    return {
        build: build
    }


module.exports = _module()
