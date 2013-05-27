class CreateAaobjetivosModelos < ActiveRecord::Migration
  def self.up
    create_table :aaobjetivos_modelos, :id => false do |table|
	table.column :aaobjetivo_id, :integer, :null => false
	table.column :modelo_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :aaobjetivos_modelos
  end
end
