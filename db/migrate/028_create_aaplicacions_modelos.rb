class CreateAaplicacionsModelos < ActiveRecord::Migration
  def self.up
    create_table :aaplicacions_modelos, :id => false do |table|
	table.column :aaplicacion_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end

  end

  def self.down
	drop_table :aaplicacions_modelos
  end
end
