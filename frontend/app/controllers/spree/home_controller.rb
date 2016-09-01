module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.includes(:possible_promotions)
      @c_taxon = Spree::Taxonomy.where('')
      @header_show_all = true
      @is_home = true
    end
  end
end
