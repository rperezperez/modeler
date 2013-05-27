class CreateAutorsModelos < ActiveRecord::Migration
  def self.up
    create_table :autors_modelos, :id => false do |table|
	table.column :modelo_id, :integer, :null => false
	table.column :autor_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :autors_modelos
  end
end
