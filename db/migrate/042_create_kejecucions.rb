class CreateKejecucions < ActiveRecord::Migration
  def self.up
    create_table "kejecucions", :force => true do |t|
      t.column :user_id, :integer
      t.column :nejecucion, :string
      t.column :comentario, :string
      t.column :limpiado, :datetime
      t.column :idproceso, :string
      t.column :finalizado, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table "kejecucions"
  end
end
