class CreateModificars < ActiveRecord::Migration
  def self.up
    create_table :modificars do |t|
	t.column :descripcion, :text
	t.column :a_nombre, :string

	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :modificars
  end
end
