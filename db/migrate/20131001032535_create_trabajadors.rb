class CreateTrabajadors < ActiveRecord::Migration
  def change
    create_table :trabajadors do |t|
      t.integer :rut
      t.string :nombre
      t.string :materno
      t.string :paterno
      t.string :perfil
      t.string :profesion
      t.string :email
      t.integer :sueldo

      t.timestamps
    end
  end
end
