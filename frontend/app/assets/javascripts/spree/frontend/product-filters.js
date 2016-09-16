$(document).ready(function(){
  $('body').on('click', '.collapse-btn .open-btn', function() {
    $(this).closest('.filter-wrapper').toggleClass('opened');
  });
  $('body').on('click', '.collapse-btn .close-btn', function() {
    $(this).closest('.filter-wrapper.opened').removeClass('opened');
  })
})
