class CreateIntroduction < ActiveRecord::Migration
  def change
    create_table :spree_introductions do |t|
      t.string :title
      t.text :body
      t.timestamps null: false
    end
  end
end
