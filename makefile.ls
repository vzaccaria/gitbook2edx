#!/usr/bin/env ./node_modules/.bin/lsc

{ parse, add-plugin } = require('newmake')



parse ->

    @add-plugin \bfy, (g, deps) ->
        @compile-files( (-> "./node_modules/.bin/browserify -t cssify -t liveify #{it.orig-complete} -o #{it.build-target}"), ".js", g, deps)

    @add-plugin \babel, (g, deps) ->
            @compile-files( (-> "./node_modules/.bin/babel #{it.orig-complete} -o #{it.build-target}"), ".js", g, deps)

    @add-plugin \livescript, (g, deps) ->
            @compile-files( (-> "./node_modules/.bin/lsc -p -c #{it.orig-complete} > #{it.build-target}" ) , ".js", g, deps)

    @collect "build", -> [
            @toDir 'bin', { strip: 'src' }, -> [
                @livescript './src/**/*.ls'
                ]
            @toDir 'bin/test', { strip: 'src/test' }, -> [
                @babel './src/test/**/*.js'
                ]
            ]

    @collect "build-assets", ->
        @dest ("./static/client.js"),  ->
                       @bfy "./assets/client.ls", "./assets/**/*.{ls,js,css}"

    @collect "exec", ->
        @command-seq -> [
            @cmd "echo '#!/usr/bin/env node' > ./bin/gitbook2edx"
            @cmd "cat ./bin/index.js >> ./bin/gitbook2edx"
            @cmd "chmod +x ./bin/gitbook2edx"
            ]

    @collect "test", -> [
      #@cmd "./test/test.sh -n"
      @make "clean"
      @make "build"
      @make "exec"
      #@cmd "cd test/test-data.tmp && DEBUG=* ../../bin/gitbook2edx gen source"
      @cmd "./node_modules/.bin/mocha -t 3000 ./bin/test/test.js"
    ]

    @collect "all", ->
        @command-seq -> [
                @make "build"
                @make "exec"
                @make "build-assets"
                @make "test"
                @cmd "./node_modules/.bin/verb"
                @cmd "./bin/gitbook2edx info test/javascript-master"
                ]

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./bin"
        @cmd "rm -rf _course"
        @cmd "rm -rf course.tar.gz"
    ]

    for l in ["major", "minor", "patch"]

        @collect "release-#l", -> [
          @command-seq -> [
            @cmd "make all"
            @cmd "./node_modules/.bin/xyz --increment #l"
          ]
        ]
