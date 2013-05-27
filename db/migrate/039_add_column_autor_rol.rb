class AddColumnAutorRol < ActiveRecord::Migration
  def self.up
	add_column :autors, :rol, :string
  end

  def self.down
	drop_column :autors, :rol
  end
end
