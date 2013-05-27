class CreateIkeplers < ActiveRecord::Migration
  def self.up
    create_table :ikeplers do |t|
   t.column :implementacion_id, :integer, :null => false
  t.column :nombre, :string,:null => false
  t.column :clase, :string, :null => false
  t.column :tipo, :string, :null => false
  t.column :created_at, :timestamp
  t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :ikeplers
  end
end
