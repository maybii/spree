class AddIsVipToSpreeRoles < ActiveRecord::Migration
  def change
    add_column :spree_roles, :is_vip, :boolean, default: false
  end
end
