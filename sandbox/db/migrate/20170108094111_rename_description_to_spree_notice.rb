class RenameDescriptionToSpreeNotice < ActiveRecord::Migration
  def change
    rename_column :spree_notices, :description, :body
    change_column :spree_notices, :body, :text
  end
end
