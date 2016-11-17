class CreateNotice < ActiveRecord::Migration
  def change
    create_table :spree_notices do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
