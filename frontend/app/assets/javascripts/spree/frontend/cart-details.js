$(document).ready(function(){
  $('.btn-select-all input[name=cartCheckAll]').on('click', function() {
    if($('.btn-select-all input[name=cartCheckAll]').prop('checked')) {
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', false);
      $('#cart-detail .cart-item-checkbox input').prop('checked', false).closest('.line-item').removeClass('active');;
      // $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }else {
      $('.btn-select-all input[name=cartCheckAll]').prop('checked', true);
      $('#cart-detail .cart-item-checkbox input').prop('checked', true).closest('.line-item').addClass('active');
      // $('#checkout-link').removeAttr('disabled').addClass('active');
    }
    var activeItems = _.map($('#cart-detail .line-item.active'), function(item) {
      return $(item).attr('key');
    });
    $('#active_line_id').val(activeItems);
  });



  $('.cart-item-checkbox input').on('click', function() {
    if($(this).prop('checked') || $(this).attr('checked')) {
      $(this).closest('.line-item').addClass('active');
    }else {
      $(this).closest('.line-item').removeClass('active');
    }
    var hasCheckedInput = _.some(_.map($('#cart-detail .cart-item-checkbox input'), function(input) {
      return $(input).prop('checked');
    }));
    if(hasCheckedInput) {
      $('#checkout-link').removeAttr('disabled').addClass('active');
    }else {
      $('#checkout-link').attr('disabled', 'true').removeClass('active');
    }
    var activeItems = _.map($('#cart-detail .line-item.active'), function(item) {
      return $(item).attr('key');
    });
    $('#active_line_id').val(activeItems);
  });

  $('#cart-detail .line_item_quantity').change( function(e) {
    e.preventDefault();
    $.ajax({
      url: $('#update-cart').attr('action'),
      data: $('#update-cart').serialize(),
      type: $('#update-cart').attr('method'),
      success: function(result){

      },
      error: function(result){
        /* $(".shipment_total_cost").html("￥" + $shipment_price.toFixed(2));
         * var orderItemTotalPrice = parseFloat($('#order-item-total')[0].attributes['itemTotal'].value);
         * $("#summary-order-total").html("￥" + ($shipment_price + orderItemTotalPrice).toFixed(2));*/
      }
    });
    console.log(e);
  });

});
