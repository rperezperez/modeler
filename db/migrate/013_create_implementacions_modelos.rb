class CreateImplementacionsModelos < ActiveRecord::Migration
  def self.up
    create_table :implementacions_modelos, :id => false do |table|
	table.column :implementacion_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :implementacions_modelos
  end
end
