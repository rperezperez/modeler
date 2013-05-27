class AutorsController < ApplicationController
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
    @autors = Autor.paginate :page => page, :order => 'updated_at DESC', :per_page => 10

    render :layout => 'indigo'
  end

  def create_ajax
    @id = params[:clase]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Autor.find_by_id(id_ientrada)
    imp = Modelo.find_by_id(@id)
    imp.autors.push(ient)
    imp.save
    @ientradas = imp.autors
    render(:layout => 'indigo_ventanas')
  end

  def destroy_modelo
    id_ient = params[:fuente]
    @id = params[:clase]
    @prefijo = params[:prefijo]
    imp = Modelo.find_by_id(@id)
    ient = Autor.find(id_ient)
    imp.autors.delete(ient)
    imp.save
    @ientradas = imp.autors
    render :action => 'create_ajax'
  end

  def show
    @autor = Autor.find(params[:id])
  end

  def new
    @autor = Autor.new
    if params[:clase] != nil
      @clase = params[:clase]
    else
      @clase = nil
    end
  end

  def create
    @autor = Autor.new(params[:autor])
    if @autor.save
      if (params[:clase] != nil) and (params[:clase][:id] != nil)
        imp = Modelo.find_by_id(params[:clase][:id])
        imp.autors.push(@autor)
        imp.save
      end
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @autor = Autor.find(params[:id])
  end

  def update
    @autor = Autor.find(params[:id])
    if @autor.update_attributes(params[:autor])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Autor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def checkSecurity()
    if not current_user.is_admin
      redirect_to :action => 'list'
    end
  end

end
