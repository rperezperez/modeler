class CreateComentarios < ActiveRecord::Migration
  def self.up
    create_table :comentarios do |t|
    t.column :title, :string, :default => ""
    t.column :comment, :text, :default => ""
    t.column :created_at, :datetime, :null => false
    t.column :tema_id, :integer, :default => 0, :null => false
    t.column :user_id, :integer, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :comentarios
  end
end
