// Generated by LiveScript 1.3.1
(function(){
  var shelljs, bluebird, debug, _module;
  shelljs = require('shelljs');
  bluebird = require('bluebird');
  debug = require('debug')(__filename);
  _module = function(){
    var write;
    write = function(data){
      var metadata, files;
      metadata = data.metadata, files = data.files;
      return bluebird.props(files).then(function(data){
        var k, v;
        debug('Removing ./_course');
        shelljs.rm('-rf', './_course');
        shelljs.rm('-f', './course.tar.gz');
        shelljs.mkdir('-p', './_course');
        shelljs.mkdir('-p', './_course/about');
        shelljs.mkdir('-p', './_course/static');
        shelljs.cp(metadata.course.origDir + "/_assets/*", "./_course/static");
        for (k in data) {
          v = data[k];
          debug("Writing " + k);
          v.to("./_course/" + k);
        }
        return new bluebird(function(resolve, rej){
          debug('Packing up with `tar cvzf course.tar.gz _course`');
          return shelljs.exec('tar cvzf course.tar.gz _course', {
            async: true
          }, function(code, output){
            if (code) {
              return rej('sorry, command failed');
            } else {
              return resolve('ok');
            }
          });
        });
      });
    };
    return {
      write: write
    };
  };
  module.exports = _module();
}).call(this);
