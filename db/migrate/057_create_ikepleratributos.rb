class CreateIkepleratributos < ActiveRecord::Migration
  def self.up
    create_table :ikepleratributos do |t|
   t.column :ikepler_id, :integer, :null => false
  t.column :nombre, :string,:null => false
  t.column :clase, :string, :null => false
  t.column :valor, :string
  t.column :created_at, :timestamp
  t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :ikepleratributos
  end
end
