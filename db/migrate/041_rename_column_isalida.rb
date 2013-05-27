class RenameColumnIsalida < ActiveRecord::Migration
  def self.up
	rename_column (:implementacions_isalidas, :isalida_id, :ientrada_id)
  end

  def self.down
	rename_column (:implementacions_isalidas, :ientrada_id, :isalida_id)
  end
end
