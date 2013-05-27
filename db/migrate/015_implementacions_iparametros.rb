class ImplementacionsIparametros < ActiveRecord::Migration
  def self.up
    create_table :implementacions_iparametros, :id => false do |table|
	table.column :implementacion_id, :integer, :null => false
	table.column :iparametro_id, :integer, :null => false
    end

  end

  def self.down
	drop_table :implementacions_iparametros
  end
end
