class AddResumenImplementacion < ActiveRecord::Migration
  def self.up
    add_column(:implementacions, :resumen, :text)
  end

  def self.down
    remove_column(:implementacions, :resumen)
  end
end
