class CreateExternalsources < ActiveRecord::Migration
  def self.up
    create_table :externalsources do |t|
      t.string :nombre
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :externalsources
  end
end
