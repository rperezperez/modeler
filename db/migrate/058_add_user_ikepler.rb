class AddUserIkepler < ActiveRecord::Migration
  def self.up
    add_column(:ikeplers, :user_id, :integer)
  end

  def self.down
    remove_column(:ikeplers, :user_id)
  end
end
