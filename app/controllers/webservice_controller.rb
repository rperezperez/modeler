class WebserviceController < ApplicationController
  
  before_filter :login_required, :except => [:modelo, :index]
          
  def modelo
    acronimo = params[:acronimo] || 'MOD10A2'
    
    @modelo = Modelo.find_by_acronimo(acronimo)
    
    respond_to do |wants|
      wants.xml do
        render :xml => @modelo.to_xml(:include => [:autors, :implementacions])
      end
      wants.html do
        render :text => 'Habilitado descarga en xml'
      end
    end
    
  end
end
