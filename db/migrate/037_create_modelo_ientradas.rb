class CreateModeloIentradas < ActiveRecord::Migration
  def self.up
    create_table :ientradas_modelos, :id => false do |table|
	table.column :ientrada_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end
  end

  def self.down
    drop_table "ientradas_modelos"
  end
end
