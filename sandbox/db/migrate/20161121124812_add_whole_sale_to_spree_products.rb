class AddWholeSaleToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :wholesale_count, :int, default: 0
  end
end
