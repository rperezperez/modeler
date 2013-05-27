class AddColumnKeplerejecucionImplementacion < ActiveRecord::Migration
  def self.up
      add_column :implementacions, :kepler_servidor_xml, :string
      add_column :implementacions, :kepler_servidor_tar, :string
  end

  def self.down
    drop_column :implementacions, :kepler_servidor_xml
    drop_column :implementacions, :kepler_servidor_tar
  end
end
