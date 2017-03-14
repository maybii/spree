module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.includes(:possible_promotions).order('id DESC').limit(12)
      # @random_products = Spree::Product.where('').sample(12)
      @on_sale_products = @searcher.retrieve_products.where(promotionable: true).order('id DESC').limit(12)
      @best_products = Spree::Product.order("sales_amount DESC").limit(12)
      @header_show_all = true
      @is_home = true
      if spree_current_user
        @order_unpaid_count = spree_current_user.orders.where.not(payment_state: 'paid').count
        @order_shipping_count = spree_current_user.orders.where(payment_state: 'paid').count
      end
      @notices = Spree::Notice.where('').order('created_at DESC').limit(3)
      @introductions = Spree::Introduction.where('').order('created_at DESC').limit(3)
    end
  end
end
