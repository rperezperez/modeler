class CreateImplementacions < ActiveRecord::Migration
  def self.up
    create_table :implementacions do |t|
	t.column :nombre, :string, :null => false
	t.column :descarga, :string
	t.column :version, :string
	t.column :tipo, :string
	t.column :c_disponibilidad, :string
	t.column :c_descarga, :string
	t.column :c_version, :string
	t.column :c_lenguaje, :text
	t.column :c_bloques, :text
	t.column :c_path1, :string
	t.column :c_path2, :string
	t.column :plataforma, :string
	t.column :licencia, :string
	t.column :r_software, :text
	t.column :r_hardware, :text
	t.column :limitaciones, :text
	t.column :bugs, :text

	t.column :t_ejecucion, :string

	t.column :created_at, :timestamp
	t.column :updated_at, :timestamp

    end
  end

  def self.down
    drop_table :implementacions
  end
end
