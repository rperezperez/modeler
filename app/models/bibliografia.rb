class Bibliografia < ActiveRecord::Base
  has_and_belongs_to_many :modelos, :uniq => true

  validates_presence_of :uri, :descripcion

  def label
    self.descripcion
  end

end
