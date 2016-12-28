class AddDescriptionToNotice < ActiveRecord::Migration
  def change
    add_column :spree_notices, :description, :string
  end
end
