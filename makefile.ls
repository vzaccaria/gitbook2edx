#!/usr/bin/env lsc 

{ parse, add-plugin } = require('newmake')



parse ->
    @collect "build", -> [
            @toDir 'bin', { strip: 'src' }, -> [
                @livescript './src/*.ls'
                ]
            ]

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
                ]

    @collect "clean", -> [
        @remove-all-targets()
        @cmd "rm -rf ./bin"
    ]



        

