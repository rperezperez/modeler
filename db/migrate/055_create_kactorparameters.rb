class CreateKactorparameters < ActiveRecord::Migration
  def self.up
    create_table :kactorparameters do |t|
  t.column :kactor_id, :integer, :null => false
  t.column :nombre, :string,:null => false
  t.column :clase, :string, :null => false
  t.column :documentacion, :text
  t.column :created_at, :timestamp
  t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :kactorparameters
  end
end
