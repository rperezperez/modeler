class CreateExternalsourceEntradas < ActiveRecord::Migration
  def self.up
    create_table :externalsource_entradas do |t|
      t.integer :externalsource_id
      t.integer :ientrada_id
      t.string :id_eml
      t.string :version
      t.string :datatable

      t.timestamps
    end
  end

  def self.down
    drop_table :externalsource_entradas
  end
end
