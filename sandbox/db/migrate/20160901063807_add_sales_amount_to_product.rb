class AddSalesAmountToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :sales_amount, :int, default: 0
  end
end
