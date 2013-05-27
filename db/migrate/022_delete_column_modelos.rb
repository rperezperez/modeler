class DeleteColumnModelos < ActiveRecord::Migration
  def self.up
	remove_column(:modelos, :ambito)
	remove_column(:modelos, :aplicacion)
	remove_column(:modelos, :limitaciones)
	remove_column(:modelos, :procedimiento)
	remove_column(:modelos, :p_gestion)
  end

  def self.down	
	add_column(:modelos, :ambito, :text)
	add_column(:modelos, :aplicacion, :text)
	add_column(:modelos, :limitaciones, :text)
	add_column(:modelos, :p_gestion, :text)
  end
end
