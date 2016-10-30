class RemoveShowInFooterFromSpreePages < ActiveRecord::Migration
  def self.up
    remove_column :spree_pages, :show_in_footer
  end

  def self.down
    add_column :spree_pages, :show_in_footer, :boolean, default: false, null: false
  end
end
