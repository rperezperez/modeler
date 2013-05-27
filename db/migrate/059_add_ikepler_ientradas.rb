class AddIkeplerIentradas < ActiveRecord::Migration
  def self.up
	remove_column(:ikeplers, :implementacion_id)
	add_column(:ikeplers, :ientrada_id, :integer)
  end

  def self.down
	remove_column(:ikeplers, :ientrada_id)
	add_column(:ikeplers, :implementacion_id, :integer)
  end
end
