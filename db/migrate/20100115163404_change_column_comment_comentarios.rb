class ChangeColumnCommentComentarios < ActiveRecord::Migration
  def self.up
    remove_column :comentarios, "comment"
    add_column :comentarios, :texto, :text
  end

  def self.down
    remove_column :comentarios, :texto
    add_column :comentarios, "comment"
  end
end
