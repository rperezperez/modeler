class Ayuda < ActiveRecord::Base

  def self.texto(tab, cam)
    
     ayu = Ayuda.find(:first, :conditions => ["tabla = ? and campo = ?", tab, cam])
     if ayu != nil
       return ayu.comentario
     else
       return "Sin Ayuda"
     end
  end

end
