class CreateIentradas < ActiveRecord::Migration
  def self.up
    create_table :ientradas do |t|
	t.column :descripcion, :text
	t.column :tipo, :string
	t.column :formato, :string
	t.column :disponibilidad, :text
	t.column :path1, :string

	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :ientradas
  end
end
