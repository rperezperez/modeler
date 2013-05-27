class CreateIparametros < ActiveRecord::Migration
  def self.up
    create_table :iparametros do |t|
	t.column :parametro, :string
	t.column :valor, :string
	
	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :iparametros
  end
end
