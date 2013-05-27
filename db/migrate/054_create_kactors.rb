class CreateKactors < ActiveRecord::Migration
  def self.up
    create_table :kactors do |t|
  t.column :nombre, :string,:null => false
  t.column :clase, :string, :null => false
  t.column :documentacion, :text
  t.column :src, :text
  t.column :created_at, :timestamp
  t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :kactors
  end
end
