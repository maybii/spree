Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'remote_cart_form',
                     :replace => "erb[loud]:contains('form_for :order')",
                     :text => "<%= form_for :order, url: populate_orders_path(format: 'js'), remote: true do |f| %>")
