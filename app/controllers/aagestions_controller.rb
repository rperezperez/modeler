class AagestionsController < ApplicationController
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
    @aagestions = Aagestion.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
    render :layout => 'indigo'
  end

  def create_ajax
    @id = params[:clase]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Aagestion.find_by_id(id_ientrada)
    imp = Modelo.find_by_id(@id)
    imp.aagestions.push(ient)
    imp.save
    @ientradas = imp.aagestions
    render(:layout => 'indigo_ventanas')
  end

  def destroy_modelo
    id_ient = params[:fuente]
    @id = params[:clase]
    @prefijo = params[:prefijo]
    imp = Modelo.find_by_id(@id)
    ient = Aagestion.find(id_ient)
    imp.aagestions.delete(ient)
    imp.save
    @ientradas = imp.aagestions
    render :action => 'create_ajax'
  end

  def show
    @aagestion = Aagestion.find(params[:id])
  end

  def new
    @aagestion = Aagestion.new
    if params[:clase] != nil
      @clase = params[:clase]
    else
      @clase = nil
    end
  end

  def create
    @aagestion = Aagestion.new(params[:aagestion])
    if @aagestion.save
      if (params[:clase] != nil) and (params[:clase][:id] != nil)
        imp = Modelo.find_by_id(params[:clase][:id])
        imp.aagestions.push(@aagestion)
        imp.save
      end
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @aagestion = Aagestion.find(params[:id])
  end

  def update
    @aagestion = Aagestion.find(params[:id])
    if @aagestion.update_attributes(params[:aagestion])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Aagestion.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

   def checkSecurity()
    if not current_user.is_admin
      redirect_to :action => 'list'
    end
  end

end
