class AlterIentradas < ActiveRecord::Migration
  def self.up
	add_column :ientradas, :user_id, :integer, :null => false
  end

  def self.down
	drop_column :ientradas, :user_id
  end
end
