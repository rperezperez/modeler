class CreateAagestions < ActiveRecord::Migration
  def self.up
    create_table :aagestions do |t|
	t.column :descripcion, :string

	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :aagestions
  end
end
