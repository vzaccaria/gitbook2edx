/* @flow */

var chai = require('chai')
chai.use(require('chai-as-promised'))
chai.should()
var Promise = require('bluebird')
var _ = require('lodash')
var fs = require('fs');
var {
  mkdir, rm, cp, test, cat
} = require('shelljs')
var uid = require('uid')


/**
 * Promised version of shelljs exec
 * @param  {string} cmd The command to be executed
 * @return {Promise}     A Promise for the command output
 */
function exec(cmd) {
  "use strict"
  return new Promise((resolve, reject) => {
    require('shelljs').exec(cmd, {
      async: true,
      silent: true
    }, (code, output) => {
      if (code !== 0) {
        reject(output)
      } else {
        resolve(output)
      }
    })
  })
}

/**
 * Remove time dependent data from input string
 * @param  {string} s input string
 * @return {string}   sanitized string
 */
function sanitize(s) {
  "use strict"
  s = s.replace(/url_name=\"[^\"]*\"/g, '')
  s = s.replace(/start=\"[^\"]*\"/g, '')
  s = s.replace(/end=\"[^\"]*\"/g, '')
  s = s.replace(/start=\'[^\']*\'/g, '')
  s = s.replace(/end=\'[^\']*\'/g, '')
  return s
}

var projRoot = `${__dirname}/../..`
var testRoot = `${projRoot}/test/test-ref/_course`
var currTestDir = `${projRoot}/test/test-data.tmp`

/**
 * Set of files to be tested
 * @type {Object}
 */
var fileComparison = {
  "_course/course.xml": "course.xml",
  "_course/about/overview.html": "about/overview.html",
  "_course/about/short_description.html": "about/short_description.html",
  "_course/policies/2014-spring/grading_policy.json": "policies/2014-spring/grading_policy.json"
}


/*global describe, it, before, beforeEach, after, afterEach */

before(() => {
  "use strict"
  rm('-rf', currTestDir)
  mkdir(currTestDir)
  cp('-R', `${projRoot}/test/javascript-master/*`, `${currTestDir}/source`)
  process.chdir(currTestDir)

})

describe('#command', () => {
  "use strict"

  it('should show help', () => {
    var usage = fs.readFileSync(`${projRoot}/docs/usage.md`, 'utf8')
    return exec(`${projRoot}/bin/gitbook2edx -h`).should.eventually.contain(usage)
  })

  it('should fail when gitbook does not exist', () => {
    return exec(`${projRoot}/bin/gitbook2edx gen sour`).should.be.rejected
  })

  it('should convert an existing gitbook without error', () => {
    return exec(`${projRoot}/bin/gitbook2edx gen source`)
  })

})

_.mapValues(fileComparison, (v, k) => {
  "use strict"
  describe(`#${k}`, () => {

    it('should be created', () => {
      test('-e', `${currTestDir}/${k}`).should.be.equal(true)
    })

    it('should be equal to reference', () => {
      var actual = sanitize(cat(`${currTestDir}/${k}`))
      var ref = sanitize(cat(`${testRoot}/${v}`))
      actual.should.be.equal(ref)
    })

  })
})