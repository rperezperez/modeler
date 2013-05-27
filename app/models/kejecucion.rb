class Kejecucion < ActiveRecord::Base
  belongs_to :user
  belongs_to :implementacion

  def label
    self.user.nombre + " "+ self.comentario
  end


end
