class ChangeComentarioStringText < ActiveRecord::Migration
  def self.up
    remove_column :kejecucions, :comentario
    add_column :kejecucions, :comentario, :text
  end

  def self.down
    remove_column :kejecucions, :comentario
    add_column :kejecucions, :comentario, :string
  end
end
