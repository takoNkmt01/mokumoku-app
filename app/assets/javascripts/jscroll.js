$(document).on('turbolinks:load', function() {
  $('.jscroll').jscroll({
    contentSelector: '.jscroll',
    nextSelector: 'a.next',
    loadingHtml: '読み込み中'
  });
});