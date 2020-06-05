$(document).on('turbolinks:load', function() {
  $('.jscroll').jscroll({
    contentSelector: '.jscroll',
    nextSelector: 'a.next',
    loadingHtml: '<div class="d-flex justify-content-center"><div class="spinner-border text-secondary" role="status"><span class="sr-only">Loading...</span></div></div>'
  });
});