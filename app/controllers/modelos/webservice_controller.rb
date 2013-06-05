require "rexml/document"
include REXML  # so that we don't have to prefix everything with REXML::...

class Modelos::WebserviceController < ApplicationController
  wsdl_service_name 'Modelos::Webservice'
  web_service_api Modelos::WebserviceApi

  web_service_scaffold :invocation
  
  skip_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :login_required
  
  def showwsdl
    redirect_to :action => 'wsdl'
  end
  
  
  def hello(nombre)
    render :text => "Hola #{nombre}!!!"
  end
  
  def get(acronimo)
    @modelo = Modelo.find(:first, :conditions => ["acronimo = ?", acronimo])
    
    if @modelo != nil
      render :xml => @modelo.to_xml(:include => {:autors => {}, :bbasicas => {}, :bcomplementarias => {}, :implementacions => {:include => {:ientradas => {}, :iparametros => {}, :isalidas => {}}}})
    else
      render :text => "<error><description>No existe el modelo solicitado</description></error>"
    end
  end
  
  def list
    @modelos = Modelo.find(:all, :select => "acronimo, nombre, resumen")
    render :xml => @modelos.to_xml, :skip_types => true
  end
  
  def listimplementaciones
    @implementacions = Implementacion.find(:all, :select => "acronimo, nombre")
    render :xml => @implementacions.to_xml, :skip_types => true
  end
    
  def ejecutar(acronimo, parametros)
      
    @implementacion = Implementacion.find_by_acronimo(acronimo)
      
    if @implementacion != nil 
      
      doc_parametros = REXML::Document.new parametros
      @nueva_clave = current_user.login.to_s+"_"+@implementacion.acronimo+"_"+(rand()*1000).to_i.to_s
            
      f = File.new(@implementacion.kepler_servidor_xml, "r")
      doc = Document.new f
      f.close

      @texto = Hash.new
      #obtenemos los parametros
      doc.elements.each("entity/property[@class='ptolemy.data.expr.Parameter']/") { |element|
        #obtenemos el parámetro si existe.
        if (doc_parametros.root.elements[element.attributes["name"].to_s] != nil and element.attributes["name"] != "Path")
          element.attributes["value"] = doc_parametros.root.elements[element.attributes["name"].to_s].text
        else
          if element.attributes["name"] == "Path"
            $Path = RAILS_ROOT+"/run_modelo/ejecuciones/"+ @nueva_clave
            File.makedirs($Path)
            $Path = Pathname::new($Path).realpath.to_s
            element.attributes["value"] = "\""+$Path+"\""
          end
        end
      }

      file = File.open($Path+"/flujo_kepler.xml", "w")
	    doc.write(file)
	    file.close

        #Almacenamos la ejecucion en el listado de trabajos
        ejecucion = Kejecucion.new
        ejecucion.user_id = current_user.id
        ejecucion.nejecucion = $Path
        #ejecucion.comentario =
        ejecucion.idproceso = @nueva_clave
        ejecucion.implementacion_id = @implementacion.id
        ejecucion.save

        #ejecutamos la implementación del modelo mediante una llamada al sistema.
        system("nohup ruby #{RAILS_ROOT}/run_modelo/run_modelo.rb #{$Path} #{@implementacion.id.to_s} #{ejecucion.id.to_s} &")

      #Enviamos el correo indicando del comienzo de la ejecución
      UserNotifier.deliver_ejecucion_start(current_user, @implementacion.nombre, @nueva_clave)
    
      render :text => @nueva_clave
    else
      render :text => "<error><description>No se ha encontrado la implementación</description></error>"
    end
    
  end
  
  def parametrosejecucion(acronimo)
    @implementacion = Implementacion.find(:first, :conditions => ["acronimo = ?", acronimo])
    if @implementacion != nil
      render :xml => @implementacion.parametros_ejecucion.to_xml
    else
      render :text => "<error><description>No existe la implementación solicitada</description></error>"
    end      
  end
  
end
