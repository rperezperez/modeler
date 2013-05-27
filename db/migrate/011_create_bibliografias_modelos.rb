class CreateBibliografiasModelos < ActiveRecord::Migration
  def self.up
    create_table :bibliografias_modelos, :id => false do |table|
	table.column :bibliografia_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :bibliografias_modelos
  end
end
