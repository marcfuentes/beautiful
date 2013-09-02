class CreateJoinTableForCategoriesAndProduct < ActiveRecord::Migration
  def up
      create_table :categories_products, :id => false do |t|
        t.integer :categories_id
        t.integer :product_id
      end

      add_index :categories_products, [:categories_id, :product_id]
      
  end

  def down
 drop_table :categories_products 
  end
end
