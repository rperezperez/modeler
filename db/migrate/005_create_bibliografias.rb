class CreateBibliografias < ActiveRecord::Migration
  def self.up
    create_table :bibliografias do |t|
	t.column :uri, :string, :null => false
	t.column :descripcion, :string
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :bibliografias
  end
end
