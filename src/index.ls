
{docopt} = require('docopt')
_ = require('lodash')
require! 'fs'

{build}    = require('./build')
{condense} = require('./condense')
{write}    = require('./write')
{gitbook} = require('./gitbook')
chalk = require('chalk')
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

if o['info']
    gitbook(source-dir)
    .then ->
        condense(book-dir, source-dir, yaml-config)
    .then ->
        console.log chalk.bold("Course name:   ") + it.course.displayName + "   (not part of the url)"
        console.log chalk.bold("Organization:  ") + it.organization.name
        console.log chalk.bold("Course number: ") + it.course.number
        console.log chalk.bold("Course run:    ") + it.course.year + "-" + it.course.season




