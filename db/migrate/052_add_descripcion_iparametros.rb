class AddDescripcionIparametros < ActiveRecord::Migration
  def self.up
        add_column(:iparametros, :descripcion, :text)
  end

  def self.down
        remove_column(:iparametros, :descripcion)
  end
end
