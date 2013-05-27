class Aagestion < ActiveRecord::Base
  def label
    self.descripcion
  end

end
