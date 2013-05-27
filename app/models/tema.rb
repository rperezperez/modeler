class Tema < ActiveRecord::Base

 acts_as_taggable

  belongs_to :user

  has_many :comentarios

  def label
    self.titulo
  end

  def self.blog_list
    @temas = Tema.find(:all, :limit => 10, :order => 'created_at desc')
  end

end
