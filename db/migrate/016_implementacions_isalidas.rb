class ImplementacionsIsalidas < ActiveRecord::Migration
  def self.up
    create_table :implementacions_isalidas, :id => false do |table|
	table.column :implementacion_id, :integer, :null => false
	table.column :isalida_id, :integer, :null => false
    end
  end

  def self.down
	drop_table :implementacions_isalidas
  end
end
