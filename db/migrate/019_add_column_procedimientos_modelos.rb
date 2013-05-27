class AddColumnProcedimientosModelos < ActiveRecord::Migration
  def self.up
	add_column :modelos, :procedimiento, :string
  end

  def self.down
     remove_column :modelos, :procedimientos
  end
end
