class CreateLimitacionsModelos < ActiveRecord::Migration
  def self.up
    create_table :limitacions_modelos, :id => false do |table|
	table.column :limitacion_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end

  end

  def self.down
	drop_table :limitacions_modelos
  end
end
