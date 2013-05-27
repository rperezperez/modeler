class ChangeValorIparametros < ActiveRecord::Migration
  def self.up
    change_column(:iparametros, :valor, :string)
  end

  def self.down
    change_column(:iparametros, :valor, :text)
  end
end
