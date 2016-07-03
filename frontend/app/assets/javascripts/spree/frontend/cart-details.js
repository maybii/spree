$(document).ready(function(){
  $('.btn-select-all input[name=cartCheckAll]').on('click', function() {
    if($('.btn-select-all input[name=cartCheckAll]').prop('checked')) {
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', false);
      $('#cart-detail .cart-item-checkbox input').prop('checked', false).closest('.line-item').removeClass('active');;
      $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }else {
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', true);
      $('#cart-detail .cart-item-checkbox input').prop('checked', true).closest('.line-item').addClass('active');
      $('#checkout-link').removeAttr('disabled').addClass('active');
    }
    var activeItems = _.map($('#cart-detail .line-item.active'), function(item) {
      return $(item).attr('key')
    })
    $('#active_line_id').val(activeItems)
  })



  $('.cart-item-checkbox input').on('click', function() {
    if($(this).prop('checked') || $(this).attr('checked')) {
      $(this).closest('.line-item').addClass('active')
    }else {
      $(this).closest('.line-item').removeClass('active')
    }
    var hasCheckedInput = _.some(_.map($('#cart-detail .cart-item-checkbox input'), function(input) {return $(input).prop('checked')}))
    if(hasCheckedInput) {
      $('#checkout-link').removeAttr('disabled').addClass('active');
    }else {
      $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }
    var activeItems = _.map($('#cart-detail .line-item.active'), function(item) {
      return $(item).attr('key')
    })
    $('#active_line_id').val(activeItems)
  })
})
