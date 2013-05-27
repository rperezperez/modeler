class AlterDescripcionBibliografia < ActiveRecord::Migration
  def self.up
    remove_column :bibliografias, :descripcion
    add_column :bibliografias, :descripcion, :text
  end

  def self.down
    remove_column :bibliografias, :descripcion
    add_column :bibliografias, :descripcion, :string
  end
end
