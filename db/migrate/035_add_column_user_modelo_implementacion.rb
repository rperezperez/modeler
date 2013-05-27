class AddColumnUserModeloImplementacion < ActiveRecord::Migration
  def self.up
	add_column :modelos, :user_id, :integer, :null => false
	add_column :implementacions, :user_id, :integer, :null => false
  end

  def self.down
	drop_column :modelos, :user_id
	drop_column :implementacions, :user_id
  end
end
