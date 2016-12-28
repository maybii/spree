# coding: utf-8
module Spree
  class TaxonsController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    helper 'spree/products'

    respond_to :html

    def show
      property_filters = [params[:brand], params[:location], params[:category]].delete_if(&:blank?).uniq
      order_filters = "#{params[:order]} #{(params[:sort] || 'ASC')}" if params[:order] and params[:order] != 'price'

      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))

      all_products = @searcher.all_products(false)
      all_properties = Spree::ProductProperty.joins(:property).where("product_id": all_products.map(&:id))

      @all_locations = all_properties.where("spree_properties.name" => "原产国").map(&:value).compact.uniq.sort - ['见包装瓶盖所示']
      @all_brands = all_properties.where("spree_properties.name" => "产品品牌").map(&:value).compact.uniq.sort - ['见包装瓶盖所示']
      @all_categries = all_products.joins(:taxons).where("").pluck("spree_taxons.name").uniq - ['见包装瓶盖所示']

      if(params[:order] == 'price')
        all_products = all_products.ascend_by_master_price if params[:sort].upcase == 'ASC'
        all_products = all_products.descend_by_master_price if params[:sort].upcase == 'DESC'
      else
        all_products = all_products.order( order_filters )
      end

      @products = @searcher.retrieve_products(all_products)
                  .includes(:possible_promotions)

      if(property_filters.present?)
        @products = @products.joins(:product_properties).where("spree_product_properties.value"=> property_filters)
      end

      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    private

    def accurate_title
      @taxon.try(:seo_title) || super
    end
  end
end
