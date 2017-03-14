# coding: utf-8
module Spree
  class ProductsController < Spree::StoreController
    before_action :load_product, only: :show
    before_action :load_taxon, only: :index

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'

    respond_to :html

    def new_products
      @searcher = build_searcher(params.merge(include_images: true))
      all_products = @searcher.all_products.active.order('id DESC')
      @products = @searcher.retrieve_products(all_products)
    end

    def on_sale
      @searcher = build_searcher(params.merge(include_images: true))
      all_products = @searcher.all_products.active.where(promotionable: true).order('id DESC')
      @products = @searcher.retrieve_products(all_products)
    end

    def index
      property_filters = [params[:brand], params[:location], params[:category]].delete_if(&:blank?).uniq
      order_filters = "#{params[:order]} #{(params[:sort] || 'ASC')}" if params[:order] and params[:order] != 'price'

      @searcher = build_searcher(params.merge(include_images: true))

      all_products = @searcher.all_products

      all_properties = Spree::ProductProperty.joins(:property).where("product_id": all_products.map(&:id))

      @all_locations = all_properties.where("spree_properties.name" => "原产国").map(&:value).compact.uniq.sort - ['见包装瓶盖所示']
      @all_brands = all_properties.where("spree_properties.name" => "产品品牌").map(&:value).compact.uniq.sort - ['见包装瓶盖所示']
      @all_categries = all_products.joins(:taxons).where("").pluck("spree_taxons.name").uniq - ['见包装瓶盖所示']

      @products = @searcher.retrieve_products(all_products)
                  .includes(:possible_promotions)
                  .order( order_filters )

      if(property_filters.present?)
        @products = @products.joins(:product_properties).where("spree_product_properties.value"=> property_filters)
      end

      if(params[:order] == 'price')
        @products = @products.ascend_by_master_price if params[:sort].upcase == 'ASC'
        @products = @products.descend_by_master_price if params[:sort].upcase == 'DESC'
      end
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    ########## Show ##########
    def show
      @useful_category = ["产品品牌", "生产商", "保质期"]
      @variants = @product.variants_including_master.
                           spree_base_scopes.
                           active(current_currency).
                           includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @product_country = @product_properties.joins(:property).find_by("spree_properties.name" => "原产国")
      @product_brand = @product_properties.joins(:property).find_by("spree_properties.name" => "产品品牌")
      @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
      redirect_if_legacy_path
    end


    private
      def accurate_title
        if @product
          @product.meta_title.blank? ? @product.name : @product.meta_title
        else
          super
        end
      end

      def load_product
        if try_spree_current_user.try(:has_spree_role?, "admin")
          @products = Product.with_deleted
        else
          @products = Product.active(current_currency)
        end
        @product = @products.includes(:variants_including_master).friendly.find(params[:id])
      end

      def load_taxon
        @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
      end

      def redirect_if_legacy_path
        # If an old id or a numeric id was used to find the record,
        # we should do a 301 redirect that uses the current friendly id.
        if params[:id] != @product.friendly_id
          params.merge!(id: @product.friendly_id)
          return redirect_to url_for(params), status: :moved_permanently
        end
      end
  end
end
