require 'ftools'
require "rexml/document"
include REXML  # so that we don't have to prefix everything with REXML::...

class EjecucionController < ApplicationController
  layout 'indigo_ventanas', :except => [:feed]

  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => [:feed]

  def list
    page = params[:page] || 1  	
    @kejecucions = Kejecucion.paginate :page => page, :order => 'updated_at DESC', :per_page => 10

    render(:layout => 'indigo')
  end

  def index
    implementacion_id = params[:id]
    if implementacion_id != nil
      @implementacion = Implementacion.find(implementacion_id)

      @texto = @implementacion.parametros_ejecucion
    else
      render(:text => 'necesita el parametro de la implementacion que se va a ejecutar')
    end
  end


  def lanzar
    implementacion_id = params[:implementacion][:id]
  	
    if implementacion_id != nil
      @implementacion = Implementacion.find(implementacion_id)

      @nueva_clave = current_user.login.to_s+"_"+@implementacion.acronimo+"_"+(rand()*1000).to_i.to_s
            
      f = File.new(@implementacion.kepler_servidor_xml, "r")
      doc = Document.new f
      f.close

      @texto = Hash.new
      #obtenemos los parametros
      doc.elements.each("entity/property[@class='ptolemy.data.expr.Parameter']/") { |element|
        #obtenemos el parámetro si existe.
        if (params[:kepler][element.attributes["name"].to_s] != nil and element.attributes["name"] != "Path")
          element.attributes["value"] = "\""+params[:kepler][element.attributes["name"]]+"\""
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
        ejecucion.implementacion_id = implementacion_id
        ejecucion.save

        #ejecutamos la implementación del modelo mediante una llamada al sistema.
        system("nohup ruby #{RAILS_ROOT}/run_modelo/run_modelo.rb #{$Path} #{implementacion_id} #{ejecucion.id.to_s} &")

      #Enviamos el correo indicando del comienzo de la ejecución
      UserNotifier.deliver_ejecucion_start(current_user, @implementacion.nombre, @nueva_clave)

    else
      render(:text => 'necesita el parametro de la implementacion que se va a ejecutar')
    end
    
  end

  def ejecucion
    @key = params[:key]
    @estado = `cat #{RAILS_ROOT}/run_modelo/ejecuciones/#{@key}/log_rmodelo.txt`
    @estado.gsub!(/\n/, "<br/>")
    render(:layout => false)
  end

  def estado
    @nueva_clave = params[:key]
    render(:layout => 'indigo')
  end

  def implementacion
    id = params[:id]
    @modelo = Modelo.find_by_id(id)
  end

  def feed
    @temas = Tema.find(:all, :order => "updated_at", :limit => 20)
    @modelos = Modelo.find(:all, :order => "updated_at", :limit => 20)
    @ejecuciones = Kejecucion.find(:all, :order => "updated_at", :limit => 20)
#    render_without_layout
#    @headers["Content-Type"] = "application/xml; charset=utf-8"
  end

end
