class ImplementacionsController < ApplicationController

  layout 'indigo_ventanas'

  before_filter :checkSecurity, :only => [:edit, :update, :delete]


  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1  	
    @implementacions = Implementacion.paginate :page => page, :order => 'updated_at DESC', :per_page => 10

    render :layout => 'indigo'
  end

 def create_ajax
    @id = params[:clase]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Implementacion.find_by_id(id_ientrada)
    imp = Modelo.find_by_id(@id)
    imp.implementacions.push(ient)
    imp.save
    @ientradas = imp.implementacions
    render(:layout => 'indigo_ventanas')
  end

  def destroy_modelo
    id_ient = params[:fuente]
    @id = params[:clase]
    @prefijo = params[:prefijo]
    imp = Modelo.find_by_id(@id)
    ient = Implementacion.find(id_ient)
    imp.implementacions.delete(ient)
    imp.save
    @ientradas = imp.implementacions
    render :action => 'create_ajax'
  end

  def show
    @implementacion = Implementacion.find(params[:id])
  end

  def new
    @implementacion = Implementacion.new
      if params[:clase] != nil
      @clase = params[:clase]
    else
      @clase = nil
    end

  end

  def create
    @implementacion = Implementacion.new(params[:implementacion])
    @implementacion.user_id = current_user.id
    if @implementacion.save
      if (params[:clase] != nil) and (params[:clase][:id] != nil)
        imp = Modelo.find_by_id(params[:clase][:id])
        imp.implementacions.push(@implementacion)
        imp.save
      end
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @implementacion = Implementacion.find(params[:id])
  end

  def update
    @implementacion = Implementacion.find(params[:id])
    if @implementacion.update_attributes(params[:implementacion])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Implementacion.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def checkSecurity()
    record = Implementacion.find(params[:id])
    if not current_user.Check(record)
      redirect_to :action => 'list'
    end
  end

end
