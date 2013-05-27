class Aaplicacion < ActiveRecord::Base
  def label
    self.descripcion
  end
end
