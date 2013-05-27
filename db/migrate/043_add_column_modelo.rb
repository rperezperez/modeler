class AddColumnModelo < ActiveRecord::Migration
  def self.up
      add_column :kejecucions, :implementacion_id, :integer
  end

  def self.down
      drop_column :kejecucions, :implementacion_id
  end
end
