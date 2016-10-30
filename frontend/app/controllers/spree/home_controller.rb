module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.includes(:possible_promotions).limit(12)
      @random_products = Spree::Product.where('').sample(12)
      @best_products = Spree::Product.order("sales_amount DESC").limit(12)
      @header_show_all = true
      @is_home = true
      if spree_current_user
        @order_unpaid_count = spree_current_user.orders.where(payment_state: 'balance_due').count
        @order_shipping_count = spree_current_user.orders.where(shipment_state: 'shipped').count
      end
    end
  end
end
