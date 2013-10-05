class CreateJoinTableForFamilyAndProduct < ActiveRecord::Migration
  def up
      create_table :families_products, :id => false do |t|
        t.integer :family_id
        t.integer :product_id
      end

      add_index :families_products, [:family_id, :product_id]
      
  end

  def down
 drop_table :families_products 
  end
end
