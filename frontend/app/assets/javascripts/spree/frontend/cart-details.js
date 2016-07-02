$(document).ready(function(){
  $('.btn-select-all input[name=cartCheckAll]').on('click', function() {
    if($('.btn-select-all input[name=cartCheckAll]').prop('checked')) {
      console.log(222);
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', false);
      $('#cart-detail .cart-item-checkbox input').prop('checked', false);
      $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }else {
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', true);
      $('#cart-detail .cart-item-checkbox input').prop('checked', true);
      $('#checkout-link').removeAttr('disabled').addClass('active');
    }
  })

  $('.cart-item-checkbox input').on('click', function() {
    console.log(33)
    if($('#cart-detail .cart-item-checkbox input').checked) {
      $('#checkout-link').removeAttr('disabled').addClass('active');
    }else {
      $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }
  })
})
