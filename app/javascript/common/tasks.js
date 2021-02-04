$(document).on('turbolinks:load', function(){
  $('.tasks').on('click', '.edit-task-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var taskId = $(this).data('taskId');
    $('form#edit-task-' + taskId).removeClass('hidden');
  })
});
