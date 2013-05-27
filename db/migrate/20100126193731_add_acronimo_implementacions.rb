class AddAcronimoImplementacions < ActiveRecord::Migration
  def self.up
    add_column :implementacions, :acronimo, :string
    
  end

  def self.down
    remove_column :implementacions, :acronimo
  end
end
