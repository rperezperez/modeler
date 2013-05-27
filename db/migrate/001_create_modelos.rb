class CreateModelos < ActiveRecord::Migration
  def self.up
    create_table :modelos do |t|
	t.column :acronimo, :string, :unique => true, :null => false
	t.column :nombre, :string, :unique => true, :null => false
	t.column :tipo, :string
	t.column :aplicacion, :text
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :modelos
  end
end
