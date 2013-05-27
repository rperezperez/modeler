class Limitacion < ActiveRecord::Base
  def label
    self.descripcion
  end

end
