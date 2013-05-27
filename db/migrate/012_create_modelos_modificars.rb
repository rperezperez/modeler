class CreateModelosModificars < ActiveRecord::Migration
  def self.up
    create_table :modelos_modificars, :id => false do |table|
	table.column :modelo_id, :integer, :null => false
	table.column :modificar_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :modelos_modificars
  end
end
