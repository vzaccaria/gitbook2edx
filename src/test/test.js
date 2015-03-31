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

function sanitize(s) {
  "use strict"
  s = s.replace(/url_name=\"[^\"]*\"/g, '')
  s = s.replace(/start=\"[^\"]*\"/g, '')
  s = s.replace(/end=\"[^\"]*\"/g, '')
  return s
}

var projRoot = `${__dirname}/../..`
var currentUid = uid(8)
var currTestDir = `${projRoot}/${currentUid}.tmp`

var fileComparison = {
  "_course/course.xml": "test/test-ref/course-clean.xml",
  "_course/about/overview.html": "test/test-ref/about/overview.html",
  "_course/about/short_description.html": "test/test-ref/about/short_description.html",
  "_course/policies/2014-spring/grading_policy.json": "test/test-ref/policies/2014-spring/grading_policy.json"
}


/*global describe, it, before, beforeEach, after, afterEach */

before(() => {
  "use strict"
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
      var ref = sanitize(cat(`${projRoot}/${v}`))
      actual.should.be.equal(ref)
    })

  })
})

after(() => {
  "use strict"
  console.log("Shutting down operations");
  rm('-rf', currTestDir)
})