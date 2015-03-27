#!/usr/bin/env lsc

{ parse, add-plugin } = require('newmake')



parse ->

    @add-plugin \bfy, (g, deps) ->
        @compile-files( (-> "browserify -t cssify -t liveify #{it.orig-complete} -o #{it.build-target}"), ".js", g, deps)

    @collect "build", -> [
            @toDir 'bin', { strip: 'src' }, -> [
                @livescript './src/**/*.ls'
                ]
            ]

    @collect "build-assets", ->
        @dest ("./static/client.js"),  ->
                @minifyjs ->
                       @bfy "./assets/client.ls", "./assets/**/*.{ls,js,css}"

    @collect "exec", ->
        @command-seq -> [
            @cmd "echo '#!/usr/bin/env node' > ./bin/gitbook2edx"
            @cmd "cat ./bin/index.js >> ./bin/gitbook2edx"
            @cmd "chmod +x ./bin/gitbook2edx"
            ]

    @collect "all", ->
        @command-seq -> [
                @make "build"
                @make "exec"
                @make "build-assets"
                @cmd "./test/test.sh -n"
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
