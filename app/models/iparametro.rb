class Iparametro < ActiveRecord::Base
  has_and_belongs_to_many :implementacions

  validates_presence_of :parametro, :valor

  def label
    self.parametro
  end

end
