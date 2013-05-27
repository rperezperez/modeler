class CreateColumnIentradas < ActiveRecord::Migration
  def self.up
	add_column :ientradas, :mdatos, :string
  end

  def self.down
	drop_column :ientradas, :mdatos
  end
end
