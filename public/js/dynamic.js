
// Add comments with AJAX (no page reloads + effect)
// Add like button with AJAX


$('#post_likes span').click(function(event) {
  $.ajax({
    method: 'POST',
    data: {
      action: 'save',
      field: $(this).attr("likes")
      val:
    }
    }
  })

});