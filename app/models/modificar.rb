class Modificar < ActiveRecord::Base
#  has_and_belongs_to_many :modelos

  validates_presence_of :descripcion

  def label
    self.descripcion
  end

end
