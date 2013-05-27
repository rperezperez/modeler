class AddKeplerClienteImplementacions < ActiveRecord::Migration
  def self.up
    add_column(:implementacions, :kepler_cliente_xml, :string)
  end

  def self.down
    remove_column(:implementacions, :kepler_cliente_xml)
  end
end
