$ ->
  $(document).on 'change', '#countries_select', (evt) ->
    $.ajax 'update_cities',
      type: 'GET'
      dataType: 'script'
      data: {
        country_id: $("#countries_select option:selected").val()
      }
