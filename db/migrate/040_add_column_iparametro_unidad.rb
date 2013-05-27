class AddColumnIparametroUnidad < ActiveRecord::Migration
  def self.up
	add_column :iparametros, :unidad, :string
  end

  def self.down
	drop_column :iparametros, :unidad
  end
end
