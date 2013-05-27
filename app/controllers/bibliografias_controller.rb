class BibliografiasController < ApplicationController
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
    @bibliografias = Bibliografia.paginate :page => page, :order => 'updated_at DESC', :per_page => 10

    render :layout => 'indigo'
  end

  def create_ajax
    @id = params[:clase]
    @prefijo = params[:prefijo]
    id_ientrada = params[:select]
    ient = Bibliografia.find_by_id(id_ientrada)
    imp = Modelo.find_by_id(@id)
    @bbasicas = params[:bbasicas]
        if (params[:bbasicas]  == "true")
          imp.bbasicas.push(ient)
        else
          imp.bcomplementarias.push(ient)
        end

    imp.save

        if (params[:bbasicas] == "true")
          @ientradas = imp.bbasicas
        else
          @ientradas = imp.bcomplementarias
        end

    render(:layout => 'indigo_ventanas')
  end

  def destroy_modelo
    id_ient = params[:fuente]
    @id = params[:clase]
    @prefijo = params[:prefijo]
    imp = Modelo.find_by_id(@id)
    ient = Bibliografia.find(id_ient)
        if (params[:bbasicas] == "true")
          imp.bbasicas.delete(ient)
        else
          imp.bcomplementarias.delete(ient)
        end

    imp.save

        if (params[:bbasicas] == "true")
          @ientradas = imp.bbasicas
        else
          @ientradas = imp.bcomplementarias
        end
    @bbasicas = params[:bbasicas]
    render :action => 'create_ajax'
  end

  def show
    @bibliografia = Bibliografia.find(params[:id])
  end

  def new
    @bibliografia = Bibliografia.new
    if params[:clase] != nil
      @clase = params[:clase]
    else
      @clase = nil
    end
    if params[:bbasicas] == true
      @bbasica = params[:bbasicas]
    else
      @bbasica = nil
    end

  end

  def create
    @bibliografia = Bibliografia.new(params[:bibliografia])
    if @bibliografia.save
      if (params[:clase] != nil) and (params[:clase][:id] != nil)
        imp = Modelo.find_by_id(params[:clase][:id])
        if (params[:bbasicas]  == true)
          imp.bbasicas.push(@bibliografia)
        else
          imp.bcomplementarias.push(@bibliografia)
        end
        imp.save
      end
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @bibliografia = Bibliografia.find(params[:id])
  end

  def update
    @bibliografia = Bibliografia.find(params[:id])
    if @bibliografia.update_attributes(params[:bibliografia])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Bibliografia.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

 def checkSecurity()
    if not current_user.is_admin
      redirect_to :action => 'list'
    end
  end

end
