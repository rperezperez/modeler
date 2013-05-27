class Autor < ActiveRecord::Base
  has_and_belongs_to_many :modelos, :uniq => true

  validates_uniqueness_of :nombre, :message => 'Indica un nombre único'

  def label
    self.nombre
  end

end
