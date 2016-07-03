$( document ).ready(function() {
  
  // hide spinner
  $(".spinner").delay(300).hide();

  // show spinner on AJAX start
  $(document).ajaxStart(function(){
   $(".spinner").show();
  });

  // hide spinner on AJAX stop
  $(document).ajaxStop(function(){
   $(".spinner").hide();
  });

});

$(document).on("page:fetch", function(){
  $(".spinner").show();
});
$(document).on("page:change", function(){
  $(".spinner").show();
});
$(document).on("page:receive", function(){
  $(".spinner").hide();
});
