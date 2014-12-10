
{docopt} = require('docopt')
_ = require('lodash')
require! 'fs'

{build}    = require('./build')
{condense} = require('./condense')
{write}    = require('./write')
{gitbook} = require('./gitbook')
shelljs = require('shelljs')

doc = shelljs.cat(__dirname+"/../docs/usage.md")

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



