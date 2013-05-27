class CreateAagestionsModelos < ActiveRecord::Migration
  def self.up
    create_table :aagestions_modelos, :id => false do |table|
	table.column :aagestion_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :aagestions_modelos
  end
end
