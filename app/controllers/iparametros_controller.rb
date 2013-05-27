class IparametrosController < ApplicationController
  layout 'indigo_ventanas'

  before_filter :checkSecurity, :only => [:edit, :update, :delete]


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1  	
    @iparametros = Iparametro.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
    render :layout => 'indigo'
  end

  def create_ajax_iparametro
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Iparametro.find_by_id(id_ientrada)
    imp = Implementacion.find_by_id(@id)
    imp.iparametros.push(ient)
    imp.save
    @ientradas = imp.iparametros
    render(:layout => 'indigo_ventanas')
  end

  def destroy_implementacion_iparametro
    id_ient = params[:ientrada]
    @id = params[:implementacion]
    @prefijo = params[:prefijo]
    imp = Implementacion.find_by_id(@id)
    ient = Iparametro.find(id_ient)
    imp.iparametros.delete(ient)
    imp.save
    @ientradas = imp.iparametros
    render :action => 'create_ajax_iparametro', :layout => 'indigo_ventanas'
  end


  def show
    @iparametro = Iparametro.find(params[:id])
  end

  def new
    @iparametro = Iparametro.new
    if params[:implementacion] != nil
      @implementacion = params[:implementacion]
    else
      @implementacion = nil
    end
  end

  def create
    @iparametro = Iparametro.new(params[:iparametro])
    if @iparametro.save
      if (params[:implementacion] != nil) and (params[:implementacion][:id] != nil)
        imp = Implementacion.find_by_id(params[:implementacion][:id])
        imp.iparametros.push(@iparametro)
        imp.save
      end
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @iparametro = Iparametro.find(params[:id])
  end

  def update
    @iparametro = Iparametro.find(params[:id])
    if @iparametro.update_attributes(params[:iparametro])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Iparametro.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def checkSecurity()
    if not current_user.is_admin
      redirect_to :action => 'list'
    end
  end

end
