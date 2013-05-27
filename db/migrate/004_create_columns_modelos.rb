class CreateColumnsModelos < ActiveRecord::Migration
  def self.up
	add_column :modelos, :palabras_clave, :string, :null => false
	add_column :modelos, :ambito, :text, :null => false
	add_column :modelos, :resumen, :text
	add_column :modelos, :extendida, :text, :null => false
	add_column :modelos, :mapa_conceptual, :string
	add_column :modelos, :limitaciones, :text
	add_column :modelos, :usabilidad, :string
	add_column :modelos, :utilidad, :text
	add_column :modelos, :implementabilidad, :text
	add_column :modelos, :path1, :string
	add_column :modelos, :path2, :string
	add_column :modelos, :path3, :string
	add_column :modelos, :path4, :string
	add_column :modelos, :p_gestion, :text
	
  end

  def self.down
  end
end
