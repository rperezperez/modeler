class CreateAaobjetivos < ActiveRecord::Migration
  def self.up
    create_table :aaobjetivos do |t|
	t.column :descripcion, :string
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :aaobjetivos
  end
end
