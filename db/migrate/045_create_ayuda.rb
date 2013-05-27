class CreateAyuda < ActiveRecord::Migration
  def self.up
    create_table "ayudas", :force => true do |t|
      t.column :tabla, :string
      t.column :campo, :string
      t.column :comentario, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table "ayudas"
  end
end
