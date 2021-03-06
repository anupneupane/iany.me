class App
  EXTERNAL_ICONS =
    github: 'icon-github-sign'
    twitter: 'icon-twitter-sign'
    facebook: 'icon-facebook-sign'
    linkedin: 'icon-linkedin-sign'

  constructor: (@body) ->

  start: ->
    @setupSidebarToggle()
    @setupExternalLinkTooltips()
    @showLinenos()
    @setupSearch()
    @setupMathJax() if @body.is('.with-mathjax')
    @loadGists()

  setupExternalLinkTooltips: ->
    $('.external').each ->
      link = $(this)
      title = link.attr('title')
      link.attr('data-title', title)

      domain = link.attr('data-domain')
      unless domain?
        match = link.attr('href').match(/^(?:https?|ftp):\/\/([^\/]+)/)
        domain = match[1]

      if domain?
        icon = if domain == 'plus.google.com'
          '<i class="icon icon-google-plus-sign"></i> '
        else if domain in ['slides.iany.me', 'www.slideshare.net', 'speakerdeck.com', 'slid.es']
          '<i class="icon icon-youtube-play"></i> '
        else
          parts = domain.split('.')[-2..]
          iconClass = EXTERNAL_ICONS[parts[0]]
          
          if parts[1] == 'com' && iconClass
            "<i class=\"icon #{iconClass}\"></i> "
          else
            ''
        link.attr('title', icon + (title || domain))

      link.tooltip html: true if link.attr('title')

  showLinenos: ->
    $('.highlighttable-container').each ->
      container = $(this)
      linenos = container.attr('data-linenos')
      if linenos?
        container.find('td.code').before(linenos)

  setupSearch: ->
    # if js is enabled, show search results in site
    $('.navbar-form').attr('action', '/search/')

  setupMathJax: ->
    $('code.mathjax').each ->
      $this = $(this)
      if $this.parent().is('pre')
        div = $('<div class="mathjax-wrapper"></div>').html($this.text())
        $this.parent().replaceWith(div)
      else
        $this.attr('class', 'mathjax-wrapper').html('\\(' + $this.text() + '\\)')

    MathJax.Hub.Configured()

  gistsStylesheets = {}

  appendGistStylesheets: (json) ->
    return unless json.stylesheet
    stylesheet = json.stylesheet
    if stylesheet[0] == '/'
      stylesheet = 'https://gist.github.com' + stylesheet
    if !gistsStylesheets[stylesheet]
      found = $(document.head).find('link[rel=stylesheet]').filter(-> @href == stylesheet)
      if found.length == 0
        $(document.head).append '<link rel="stylesheet" href="' + stylesheet + '" />'
        gistsStylesheets[stylesheet] = true

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

  toggleSidebar: ->
    if @body.hasClass('with-sidebar')
      $.cookie('without-sidebar', '1')
      @body.removeClass('with-sidebar').addClass('without-sidebar')
    else
      $.removeCookie('without-sidebar')
      @body.removeClass('without-sidebar').addClass('with-sidebar')

  setupSidebarToggle: ->
    $('#sidebar-toggle').click (e) =>
      e.preventDefault()
      @toggleSidebar()
    if $.cookie('without-sidebar')
      @toggleSidebar()

$ ->
  $('html').removeClass('no-js').addClass('has-js')
  app = window.app = new App($('body'))
  app.start()
