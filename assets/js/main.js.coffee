class App
  constructor: (@body) ->

  start: ->
    @setupSearch()
    @setupMathJax() if @body.is('.with-mathjax')
    @loadGists()

  setupSearch: ->
    # if js is enabled, show search results in site
    $('.navbar-search').attr('action', '/search/')

  setupMathJax: ->
    mathjax = $('code.mathjax').fadeOut()
    mathjax.each ->
      $this = $(this)
      if $this.parent().is('pre')
        div = $('<div class="mathjax-wrapper"></div>').html($this.text())
        $this.parent().replaceWith(div)
      else
        $this.attr('class', 'mathjax-wrapper').html('\\(' + $this.text() + '\\)')

    # MathJax.Hub.Register.StartupHook "End Typeset", ->
    MathJax.Hub.Configured()

  gistsStylesheets = {}

  appendGistStylesheets: (json) ->
    if json.stylesheet && !gistsStylesheets[json.stylesheet]
      found = $(document.head).find('link[rel=stylesheet]').filter(-> @href == json.stylesheet)
      if found.length == 0
        $(document.head).append '<link rel="stylesheet" href="' + json.stylesheet + '" />'
        gistsStylesheets[json.stylesheet] = true

  loadGists: ->
    app = @

    # TODO: cache duplicated gists?
    $('.gist').each ->
      el = $(@)
      id = el.data('gist-id')
      file = el.data('gist-file')

      url = "https://gist.github.com/#{id}.json?file=#{file}&callback=?"
      $.ajax url,
        dataType: 'json'
        success: (json) ->
          $(json.div).replaceAll(el).trigger('gistloaded', json)
          app.appendGistStylesheets(json)

$ ->
  $('html').removeClass('no-js').addClass('has-js')
  app = window.app = new App($('body'))
  app.start()
