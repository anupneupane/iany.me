$ ->
  $('html').removeClass('no-js').addClass('has-js')
  body = $('body')

  # if js is enabled, show search results in site
  $('.navbar-search').attr('action', '/search/')

  if body.is('.with-mathjax')
    mathjax = $('code.mathjax').fadeOut()
    mathjax.each ->
      $this = $(this)
      if $this.parent().is('pre')
        div = $('<div class="mathjax-wrapper"></div>').html($this.text())
        $this.parent().replaceWith(div)
      else
        $this.attr('class', 'mathjax-wrapper').html('\\(' + $this.text() + '\\)')

    MathJax.Hub.Register.StartupHook "End Typeset", ->
      mathjax.fadeIn()
    MathJax.Hub.Configured()
