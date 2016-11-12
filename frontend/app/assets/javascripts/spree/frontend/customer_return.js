(function() {

  $('input').on('change', function() {
    console.log(123)
    debugger
    // if($('.btn-select-all input[name=cartCheckAll]').prop('checked')) {
    //   $('.btn-select-all input[name=cartCheckAll]').prop('checked', false);
    //   $('#cart-detail .cart-item-checkbox input').prop('checked', false).closest('.line-item').removeClass('active');;
    //   // $('#checkout-link').attr('disabled', 'true').removeClass('active');
    // }else {
    //   $('.btn-select-all input[name=cartCheckAll]').prop('checked', true);
    //   $('#cart-detail .cart-item-checkbox input').prop('checked', true).closest('.line-item').addClass('active');
    //   // $('#checkout-link').removeAttr('disabled').addClass('active');
    // }
    // var activeItems = _.map($('#cart-detail .line-item.active'), function(item) {
    //   return $(item).attr('key');
    // });
    // $('#active_line_id').val(activeItems);
  });
})()
