class Ikepleratributo < ActiveRecord::Base
  belongs_to :ikepler

  def self.documentacion(clase, nombre)
    actor = Kactor.find_by_clase(clase)
    return actor.kactorparameters.find_by_nombre(nombre).documentacion.to_s
  end
end
