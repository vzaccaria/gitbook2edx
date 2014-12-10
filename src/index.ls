
{docopt} = require('docopt')
_ = require('lodash')
require! 'fs'

{build}    = require('./build')
{condense} = require('./condense')
{write}    = require('./write')
{gitbook} = require('./gitbook')

doc = """
Usage:
    gitbook2edx json DIR [ -c CONFIG ]
    gitbook2edx build DIR [ -c CONFIG ]
    gitbook2edx gen DIR [ -c CONFIG ]
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

source-dir = o['DIR']
book-dir = "#{source-dir}/_book"

yaml-config = get-option('-c', '--config', "#{source-dir}/config.yaml", o)


if o['json']
    gitbook(source-dir)
    .then ->
        condense(book-dir, source-dir, yaml-config)
    .then ->
        console.log JSON.stringify(it, 0, 4)

if o['build'] 
    gitbook(source-dir)
    .then ->
        condense(book-dir, source-dir, yaml-config)
    .then build
    .then ->
        console.log it

if o['gen'] 
    gitbook(source-dir)
    .then ->
        condense(book-dir, source-dir, yaml-config)
    .then build
    .then write



