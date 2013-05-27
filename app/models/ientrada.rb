class Ientrada < ActiveRecord::Base
  has_and_belongs_to_many :implementacions
#  has_and_belongs_to_many :modelos
#  has_and_belongs_to_many :modelos, :class_name => 'Implementacion', :join_table => 'implementacions_isalidas'

 has_many :ikeplers

  belongs_to :user
  validates_presence_of :descripcion

  file_column :path1, :web_root => "metadatos/", :root_path => File.join(RAILS_ROOT, "public", "")

  def label
    self.tipo.to_s + "  -  " + self.formato.to_s
  end

#  def before_save
#  	self.user_id = current_user.id
#  end

end
