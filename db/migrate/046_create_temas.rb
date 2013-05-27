class CreateTemas < ActiveRecord::Migration
  def self.up
    create_table :temas do |t|
      t.column :titulo, :string
      t.column :cuerpo, :text
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :temas
  end
end
