class Aaobjetivo < ActiveRecord::Base
  def label
    self.descripcion
  end

end
