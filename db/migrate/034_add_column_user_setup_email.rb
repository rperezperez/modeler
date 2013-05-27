class AddColumnUserSetupEmail < ActiveRecord::Migration
  def self.up
add_column :users, :activation_code, :string, :limit => 40
add_column :users, :activated_at, :datetime
  end

  def self.down
drop_column :users, :activation_code
drop_column :users, :activated_at
  end
end
