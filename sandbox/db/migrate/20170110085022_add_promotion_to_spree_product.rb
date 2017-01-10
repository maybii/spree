class AddPromotionToSpreeProduct < ActiveRecord::Migration
  def change
    change_column :spree_products, :promotionable, :boolean, default: false
  end
end
