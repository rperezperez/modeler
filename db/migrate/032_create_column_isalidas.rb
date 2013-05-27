class CreateColumnIsalidas < ActiveRecord::Migration
  def self.up
	add_column :isalidas, :mdatos, :string
  end

  def self.down
	drop_column :isalidas, :mdatos
  end
end
