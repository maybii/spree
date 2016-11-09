Deface::Override.new(
  virtual_path: 'spree/users/show',
  name: 'show_order_return_link',
  insert_bottom: "[data-hook='links']",
  partial: 'spree/orders/return_authorizations_link'
)
