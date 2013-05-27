class CreateLimitacions < ActiveRecord::Migration
  def self.up
    create_table :limitacions do |t|
	t.column :descripcion, :text

	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :limitacions
  end
end
