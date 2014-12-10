
_module = ->

    execute-js = (link) ->
        fileref = document.createElement('script')
        fileref.setAttribute("type","text/javascript")
        fileref.setAttribute("src", link)

    execute-css = (link) ->
        fileref=document.createElement("link")
        fileref.setAttribute("rel", "stylesheet")
        fileref.setAttribute("type", "text/css")
        fileref.setAttribute("href", link)

    return {
        execute-js: execute-js 
        execute-css: execute-css
    }


module.exports = _module()


