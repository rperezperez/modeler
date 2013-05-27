class CreateAambitosModelos < ActiveRecord::Migration
  def self.up
    create_table :aambitos_modelos, :id => false do |table|
	table.column :aambito_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end

  end

  def self.down
	drop_table :aambitos_modelos
  end
end
