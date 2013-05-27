class Aambito < ActiveRecord::Base
  def label
    self.descripcion
  end

end
