class CreateIentradasImplementacions < ActiveRecord::Migration
  def self.up

    create_table :ientradas_implementacions, :id => false do |table|
	table.column :ientrada_id, :integer, :null => false
	table.column :implementacion_id, :integer, :null => false
    end

  end

  def self.down
	drop_table :ientradas_implementacions
  end
end
