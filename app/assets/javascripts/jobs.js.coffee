# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
     
$ ->
  $('form').on 'click', '.add_child', (event) ->
    association = $(this).data('association')
    template = $('#' + association + '_fields_template').html()
    regexp = new RegExp('new_' + association, 'g')
    new_id = new Date().getTime()
    
    $(this).before(template.replace(regexp, new_id))
    return false

  $('form').on 'click', '.remove_child', (event) ->
    hidden_field = $(this).prev('input[type=hidden]')[0]
    if hidden_field
      hidden_field.value = '1'

    $(this).parents('.fields').hide()
    return false
    
  $('form').on 'change', 'select[id^=job_tasks_attributes_]', (event) ->
    attrs = definitions[$(this).val()]
    template = $('#attribute_template').html()
    association = $()
    alert()
    event.preventDefault()
    
  return 
