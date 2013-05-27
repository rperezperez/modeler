class CreateAambitos < ActiveRecord::Migration
  def self.up
    create_table :aambitos do |t|
	t.column :descripcion, :string, :null => false
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp 
    end
  end

  def self.down
    drop_table :aambitos
  end
end
