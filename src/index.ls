
{docopt} = require('docopt')
_ = require('lodash')
require! 'fs'

{build} = require('./build')
{condense} = require('./condense')

doc = """
Usage:
    gitbook2edx json DIR -c CONFIG
    gitbook2edx build DIR -c CONFIG 
    gitbook2edx -h | --help 

Options:
    -h, --help              Just this help
    -c, --config CONFIG     file name of the YAML configuration of the course

Arguments:
    DIR             directory to condense into a json file

"""

get-option = (a, b, def, o) ->
    if not o[a] and not o[b]
        return def
    else 
        return o[b]

o = docopt(doc)

yaml-config = get-option('-c', '--config', 'invalid', o)


if o['json']
    condense(o['DIR'], yaml-config).then ->
        console.log JSON.stringify(it, 0, 4)

if o['build'] 
    condense(o['DIR'], yaml-config).then ->
        build(it)




