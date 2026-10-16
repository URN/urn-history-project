class ReportModel
  constructor: (opts) ->
    @title = opts.title
    @page_url = opts.page_url
    @message = opts.message
    @name = opts.name
    @turnstile_token = opts.turnstile_token
    @url = opts.url

  buildJSON: =>
    JSON.stringify
      title: @title
      page_url: @page_url
      message: @message
      name: @name
      turnstile_token: @turnstile_token

  save: (opts) ->
    FORM_URL = @url
    data = @buildJSON()
    window.reportModelData = data
    $.ajax
      url : FORM_URL
      type: "POST"
      data : data
      success: (data, textStatus, jqXHR) ->
        if data.status is "success"
          opts.success(data)
        else
          alert('There was a problem with the data your provided')
          opts.error()
      error: (jqXHR, textStatus, errorThrown) ->
        alert('Oops, something went wrong')
        opts.error()

disableReportForm = ->
  $('.report-submit').attr("disabled", true)
  $('.report-submit').addClass('disabled')
  $('.report-submit').html('<i class="fas fa-circle-notch fa-spin"></i>')


enableReportForm = ->
  $('.report-submit').attr("disabled", false)
  $('.report-submit').removeClass('disabled')
  $('.report-submit').html('Try Again')

reportThanks = (url) ->
  template = _.template $('#report-success-template').html()
  $('#report-modal-content').html template('url': url)

renderTurnstileWidgets = ->
  return unless window.turnstile?
  $('.cf-turnstile:not([data-turnstile-widget-id])').each ->
    widget_id = window.turnstile.render this,
      sitekey: $(this).attr 'data-sitekey'
    $(this).attr 'data-turnstile-widget-id', widget_id

document.addEventListener 'turbolinks:load', renderTurnstileWidgets
document.addEventListener 'turnstile:ready', renderTurnstileWidgets
document.addEventListener 'turbolinks:before-cache', ->
  return unless window.turnstile?
  $('.cf-turnstile[data-turnstile-widget-id]').each ->
    window.turnstile.remove $(this).attr 'data-turnstile-widget-id'
    $(this).removeAttr 'data-turnstile-widget-id'

frozenScrollTop = null

freezeScrolling = () ->
  # Freeze scrolling
  frozenScrollTop = $(document).scrollTop()
  document.body.style.position = "fixed"
  document.body.style.top = "-#{frozenScrollTop}px"

unfreezeScrolling = () ->
  # Unfreeze scrolling
  document.body.style.position = "static"
  $(document).scrollTop(frozenScrollTop)

document.addEventListener 'turbolinks:load', ->
  $('#report-this-page').click (e) ->
    e.preventDefault()
    freezeScrolling()
    $('#report').addClass 'report-show'
  $('[data-report-close]').click (e) ->
    e.preventDefault()
    unfreezeScrolling()
    $('#report').removeClass 'report-show'
    $('#improve').removeClass 'report-show'

  $('#improve-this-page').click (e) ->
    if localStorage.debug_mode isnt "yes"
      e.preventDefault()
      freezeScrolling()
      $('#improve').addClass 'report-show'
  $('[data-improve-close]').click (e) ->
    e.preventDefault()
    unfreezeScrolling()
    $('#improve').removeClass 'report-show'

  $('[data-report-this-page]').click (e) ->
    e.preventDefault()
    freezeScrolling()
    $('#improve').removeClass 'report-show'
    $('#report').addClass 'report-show'

  $("#report-issue-form").submit (e) ->
    e.preventDefault()

    report = new ReportModel
      title: $("#report-title", this).val()
      page_url: $("#report-page_url", this).val()
      message: $("#report-message", this).val()
      name: $("#report-name", this).val()
      turnstile_token: $("[name='cf-turnstile-response']", this).val()
      url: $(this).attr 'action'

    report.save
      success: (data) ->
        reportThanks(data.url)
      error: (data) ->
        enableReportForm()

    disableReportForm()
