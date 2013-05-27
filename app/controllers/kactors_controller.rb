class KactorsController < ApplicationController
  layout 'indigo'

  before_filter :checkSecurity, :only => [:edit, :update, :delete]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def search
    cadena = '%'+(request.raw_post || request.query_string)+'%'
    if cadena.length > 2
      @actores = Kactor.find(:all, :conditions => ["nombre LIKE ? or clase LIKE ? or documentacion LIKE ?", cadena, cadena, cadena], :limit => 20)
    else
      @actores = Array.new
    end
    render(:layout => false)
  end

  def list
#    @ientradas = Ientrada.paginate :page => 10, :order => 'created_at DESC'
    page = params[:page] || 1  	
    @kactors = Kactor.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
  end


  def show
    @kactor = Kactor.find(params[:id])
    render(:layout => 'indigo_ventanas')
  end


  def destroy
    Kactor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def checkSecurity()
    record = Kactor.find(params[:id])
    if not current_user.is_admin?
      redirect_to :action => 'list'
    end
  end

# ***************************** ikepler
  def destroy_ikepler
    @ikepler = Ikepler.find(params[:id])
      @ikepler.ikepleratributos.each{ |atributo| atributo.destroy}
      @ikepler.save
    @ikepler.destroy
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'search_ikepler', :layout => 'indigo_ventanas'
  end

def implementacion_ikepler
   @implementacion = params[:implementacion]
   @accion = params[:accion]
   @tipo = params[:tipo]
   render(:layout => 'indigo_ventanas')
end

def ientrada_ikepler
   @ientrada = params[:ientrada]
   @accion = params[:accion]
   @tipo = params[:tipo]
   render(:layout => 'indigo_ventanas')
end

  def formulario_ikepler
   @accion = params[:accion] || 'edit'

    if @accion == 'new'
      @tipo = params[:tipo]
      @actor = Kactor.find(params[:id])
      @implementacion = params[:implementacion]

      @ikepler = Ikepler.new
      @ikepler.implementacion_id = @implementacion
      @ikepler.nombre = @actor.nombre
      @ikepler.clase = @actor.clase
      @ikepler.tipo = @tipo
      for atributo in @actor.kactorparameters
        atr = Ikepleratributo.new
        atr.nombre = atributo.nombre
        atr.clase = atributo.clase
        atr.valor = ''
        @ikepler.ikepleratributos.push(atr)
      end
    else
      if @accion == 'edit'
        @ikepler = Ikepler.find(params[:id])
        @implementacion = @ikepler.implementacion_id
        @tipo = @ikepler.tipo
      end
    end

   render(:layout => 'indigo_ventanas')
  end

  def formulario_ikepler_ientrada
   @accion = params[:accion] || 'edit'

    if @accion == 'new'
      @tipo = params[:tipo]
      @actor = Kactor.find(params[:id])
      @ientrada = params[:ientrada]

      @ikepler = Ikepler.new
      @ikepler.ientrada_id = @ientrada
      @ikepler.nombre = @actor.nombre
      @ikepler.clase = @actor.clase
      @ikepler.tipo = @tipo
      for atributo in @actor.kactorparameters
        atr = Ikepleratributo.new
        atr.nombre = atributo.nombre
        atr.clase = atributo.clase
        atr.valor = ''
        @ikepler.ikepleratributos.push(atr)
      end
    else
      if @accion == 'edit'
        @ikepler = Ikepler.find(params[:id])
        @ientrada = @ikepler.ientrada_id
        @tipo = @ikepler.tipo
      end
    end

   render(:layout => 'indigo_ventanas')
  end

  def search_ikepler
   @implementacion = params[:implementacion]
   @accion = params[:accion]
   @tipo = params[:tipo]

    cadena = '%'+(request.raw_post || request.query_string)+'%'
    if cadena.length > 2
      @actores = Kactor.find(:all, :conditions => ["nombre LIKE ? or clase LIKE ? or documentacion LIKE ?", cadena, cadena, cadena])
    else
      @actores = Array.new
    end
    render(:layout => 'indigo_ventanas')
  end

  def search_ikepler_ientrada
   @ientrada = params[:ientrada]
   @accion = params[:accion]
   @tipo = params[:tipo]

    cadena = '%'+(request.raw_post || request.query_string)+'%'
    if cadena.length > 2
      @actores = Kactor.find(:all, :conditions => ["nombre LIKE ? or clase LIKE ? or documentacion LIKE ?", cadena, cadena, cadena], :limit => 20)
    else
      @actores = Array.new
    end
    render(:layout => 'indigo_ventanas')
  end

# tienden a desaparecer 
  def show_ikepler
    @ikepler = Ikepler.find(params[:id])
    render(:layout => 'indigo_ventanas')
  end

  def form_ikepler
    if params[:accion] == 'new'
      @ikepler = Ikepler.new
      if params[:implementacion] != nil
        @implementacion = params[:implementacion]
      else
        @implementacion = nil
      end
      if params[:peticion] != nil
        @peticion = params[:peticion]
      else
        @peticion = nil
      end
    end
    render :layout => 'indigo_ventanas'
  end

  def update_ikepler
    @ikepler = Ikepler.find(params[:ikepler][:id])
    @ikepler.user_id = current_user
    if @ikepler.update_attributes(params[:ikepler])
      #borramos todos los atributos de ikepler
      @ikepler.ikepleratributos.each{ |atributo| atributo.destroy}
      @ikepler.save
      #vamos obteniendo los atributos y los vamos asociando
      i = 0
      while params["ikepleratributo_"+i.to_s] != nil
        atr = Ikepleratributo.new
        atr.nombre = params["ikepleratributo_"+i.to_s][:nombre]
        atr.clase = params["ikepleratributo_"+i.to_s][:clase]
        atr.valor = params["ikepleratributo_"+i.to_s][:valor]
        atr.ikepler_id = @ikepler.id
        atr.save
        @ikepler.ikepleratributos.push(atr)
        i = i+1
      end

      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'search_ikepler', :layout => 'indigo_ventanas'
    else
      render :action => 'search_ikepler', :layout => 'indigo_ventanas'
    end
  end


  def create_ikepler
    @ikepler = Ikepler.new(params[:ikepler])
    @ikepler.user_id = current_user
    if @ikepler.save
      #vamos obteniendo los atributos y los vamos asociando
      i = 0
      while params["ikepleratributo_"+i.to_s] != nil
        atr = Ikepleratributo.new
        atr.nombre = params["ikepleratributo_"+i.to_s][:nombre]
        atr.clase = params["ikepleratributo_"+i.to_s][:clase]
        atr.valor = params["ikepleratributo_"+i.to_s][:valor]
        atr.ikepler_id = @ikepler.id
        atr.save
        @ikepler.ikepleratributos.push(atr)
        i = i+1
      end

      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'search_ikepler', :layout => 'indigo_ventanas'
    else
      render :action => 'search_ikepler', :layout => 'indigo_ventanas'
    end
  end

# hasta aqui

  def form_ikepler_ientrada
    if params[:accion] == 'new'
      @ikepler = Ikepler.new
      if params[:ientrada] != nil
        @ientrada = params[:ientrada]
      else
        @ientrada = nil
      end
      if params[:peticion] != nil
        @peticion = params[:peticion]
      else
        @peticion = nil
      end
    end
    render :layout => 'indigo_ventanas'
  end

  def update_ikepler_ientrada
    @ikepler = Ikepler.find(params[:ikepler][:id])
    @ikepler.user_id = current_user
    if @ikepler.update_attributes(params[:ikepler])
      #borramos todos los atributos de ikepler
      @ikepler.ikepleratributos.each{ |atributo| atributo.destroy}
      @ikepler.save
      #vamos obteniendo los atributos y los vamos asociando
      i = 0
      while params["ikepleratributo_"+i.to_s] != nil
        atr = Ikepleratributo.new
        atr.nombre = params["ikepleratributo_"+i.to_s][:nombre]
        atr.clase = params["ikepleratributo_"+i.to_s][:clase]
        atr.valor = params["ikepleratributo_"+i.to_s][:valor]
        atr.ikepler_id = @ikepler.id
        atr.save
        @ikepler.ikepleratributos.push(atr)
        i = i+1
      end

      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'search_ikepler_ientrada', :layout => 'indigo_ventanas'
    else
      render :action => 'search_ikepler_ientrada', :layout => 'indigo_ventanas'
    end
  end


  def create_ikepler_ientrada
    @ikepler = Ikepler.new(params[:ikepler])
    @ikepler.user_id = current_user
    if @ikepler.save
      #vamos obteniendo los atributos y los vamos asociando
      i = 0
      while params["ikepleratributo_"+i.to_s] != nil
        atr = Ikepleratributo.new
        atr.nombre = params["ikepleratributo_"+i.to_s][:nombre]
        atr.clase = params["ikepleratributo_"+i.to_s][:clase]
        atr.valor = params["ikepleratributo_"+i.to_s][:valor]
        atr.ikepler_id = @ikepler.id
        atr.save
        @ikepler.ikepleratributos.push(atr)
        i = i+1
      end

      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'search_ikepler_ientrada', :layout => 'indigo_ventanas'
    else
      render :action => 'search_ikepler_ientrada', :layout => 'indigo_ventanas'
    end
  end


end
