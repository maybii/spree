Deface::Override.new(
  virtual_path: 'spree/shared/_products',
  name: 'add_recently_viewed_products_to_products_index',
  insert_after: "#products[data-hook], [data-hook='products']",
  partial: 'spree/shared/add_recently_viewed_products'
)

Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_recently_viewed_products_to_products_show',
  insert_after: "#product_description[data-hook], [data-hook='product_description']",
  partial: 'spree/shared/add_recently_viewed_products'
)

Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'add_recently_viewed_products_to_orders_show',
  insert_after: "#order_summary[data-hook], [data-hook='order_summary']",
  partial: 'spree/shared/add_recently_viewed_products'
)

Deface::Override.new(
  virtual_path: 'spree/orders/edit',
  name: 'add_recently_viewed_products_to_cart_show',
  insert_after: "#cart-container[data-hook], [data-hook='cart-container']",
  partial: 'spree/shared/add_recently_viewed_products'
)