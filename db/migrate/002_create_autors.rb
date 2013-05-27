class CreateAutors < ActiveRecord::Migration
  def self.up
    create_table :autors do |t|
	t.column :nombre, :string, :null => false
	t.column :institucion, :string
	t.column :direccion, :string
	t.column :email, :string
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :autors
  end
end
