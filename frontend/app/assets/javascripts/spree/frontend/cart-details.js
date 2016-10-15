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


  calculatePrice = function(target){
    // calculate line item price
    var index = target.attributes['key'].value;
    var lineItem = 'tr.line-item[key=' + index + ']';
    var cartItemPrice = parseFloat($(lineItem + " .cart-item-price")[0].attributes['value'].value);
    var count = parseInt(target.value);
    $(lineItem + " .cart-item-total").html("￥" + count * cartItemPrice);

    // calculate total price
    var sum = 0;
    $('.cart-item-total').each(function(index, item){
      sum += parseFloat(item.innerHTML.trim().substr(1));
    });

    $('.total-price').html("￥" + sum);
  };

  $('input-up').onClick(function(e){
    alert('asdf');
  });

  $('#cart-detail .line_item_quantity').change( function(e) {
    e.preventDefault();
    var target = e.target;
    $.ajax({
      url: $('#update-cart').attr('action'),
      data: $('#update-cart').serialize(),
      type: $('#update-cart').attr('method'),
      success: function(result){
      },
      error: function(result){
        if(result.status == 200){
          calculatePrice(target);
        }
      }
    });
  });

});
