class IentradasController < ApplicationController
  layout 'indigo'

  before_filter :checkSecurity, :only => [:edit, :update, :delete]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @ientradas = Ientrada.paginate :page => 10, :order => 'created_at DESC'

    page = params[:page] || 1  	
    @ientradas = Ientrada.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
    
  end

  def create_ajax_ientrada
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Ientrada.find_by_id(id_ientrada)
    imp = Implementacion.find_by_id(@id)
    imp.ientradas.push(ient)
    imp.save
    @ientradas = imp.ientradas
    #render(:layout => 'indigo_ventanas')
    render :layout => false
  end

  def destroy_implementacion_ientrada
    id_ient = params[:ientrada]
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    imp = Implementacion.find_by_id(@id)
    ient = Ientrada.find(id_ient)
    imp.ientradas.delete(ient)
    imp.save
    @ientradas = imp.ientradas
    render :action => 'create_ajax_ientrada', :layout => false
  end

  def create_ajax_isalida
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Ientrada.find_by_id(id_ientrada)
    imp = Implementacion.find_by_id(@id)
    imp.isalidas.push(ient)
    imp.save
    @ientradas = imp.isalidas
    #render(:layout => 'indigo_ventanas')
    render(:layout => false)
  end

  def destroy_implementacion_isalida
    id_ient = params[:ientrada]
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    imp = Implementacion.find_by_id(@id)
    ient = Ientrada.find(id_ient)
    imp.isalidas.delete(ient)
    imp.save
    @ientradas = imp.isalidas
    render :action => 'create_ajax_isalida', :layout => false
  end


  def show
    @ientrada = Ientrada.find(params[:id])
    render(:layout => 'indigo_ventanas')
  end

  def new
    @ientrada = Ientrada.new
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

    render :layout => 'indigo_ventanas'
  end

  def create
    @ientrada = Ientrada.new(params[:ientrada])
    @ientrada.user_id = current_user.id
    if @ientrada.save
      if (params[:implementacion] != nil) and (params[:implementacion][:id] != nil)
        imp = Implementacion.find_by_id(params[:implementacion][:id])
        if (params[:implementacion][:isalida] != nil)
         imp.isalidas.push(@ientrada)
        else
         imp.ientradas.push(@ientrada)
        end
        imp.save
      end

      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new', :layout => 'indigo_ventanas'
    else
      render :action => 'new', :layout => 'indigo_ventanas'
    end
  end

  def edit
    @ientrada = Ientrada.find(params[:id])
    render(:layout => 'indigo_ventanas')
  end

  def update
    @ientrada = Ientrada.find(params[:id])
    if @ientrada.update_attributes(params[:ientrada])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit', :layout => 'indigo_ventanas'
    else
      render :action => 'edit', :layout => 'indigo_ventanas'
    end
  end

  def destroy
    Ientrada.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def checkSecurity()
    record = Ientrada.find(params[:id])
    if not current_user.Check(record)
      redirect_to :action => 'list'
    end
  end

end
