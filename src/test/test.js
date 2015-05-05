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

var testData = {
  "jsbook": {
    src: `${projRoot}/test/javascript-master/*`,
    ref: `${projRoot}/test/javascript-ref/_course`
  },
  "ocbook": {
    src: `${projRoot}/test/octave-master/*`,
    ref: `${projRoot}/test/octave-ref/_course`
  }
}

var testRoot

/* Updates testRoot */
var prepareTest = (key) => {
  "use strict"
  console.log(`Preparing for ${key}`);
  rm('-rf', currTestDir)
  mkdir(currTestDir)
  cp('-R', testData[key].src, `${currTestDir}/source`)
  process.chdir(currTestDir)
  testRoot = testData[key].ref
}

_.mapValues(testData, (v, bookType) => {
  "use strict"


  describe(`#command - ${bookType}`, () => {
    before(() => {
      prepareTest(bookType)
    })

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

  _.mapValues(fileComparison, (refFile, outFile) => {
    if ((bookType === 'jsbook') || (refFile === "course.xml")) {
      describe(`#${outFile}`, () => {
        it('should be created', () => {
          test('-e', `${currTestDir}/${outFile}`).should.be.equal(true)
        })
        console.log(refFile);
        it('should be equal to reference', () => {
          var actual = sanitize(cat(`${currTestDir}/${outFile}`))
          var ref = sanitize(cat(`${testRoot}/${refFile}`))
          actual.should.be.equal(ref)
        })
      })
    }
  })
})