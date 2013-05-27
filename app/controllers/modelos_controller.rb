class ModelosController < ApplicationController
  layout "indigo_ventanas"


  def get
    acronimo = params[:acronimo]
    
    @modelo = Modelo.find(:first, :conditions => ["acronimo = ?", acronimo])
    
    if @modelo != nil
      render :xml => @modelo.to_xml(:include => {:autors => {}, :bbasicas => {}, :bcomplementarias => {}, :implementacions => {:include => {:ientradas => {}, :isalidas => {}}}})
    else
      render :text => "<error><description>No existe el modelo solicitado</description></error>"
    end
  end


  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
	page = params[:page] || 1
	@modelos = Modelo.paginate :page => page, :per_page => 10, :order => 'updated_at DESC'
    #@modelo_pages, @modelos = paginate :modelos, :per_page => 10
    render :layout => "indigo"
  end

  def show
    @modelo = Modelo.find(params[:id])
  end

  def new
    @modelo = Modelo.new
  end

  def create
    @modelo = Modelo.new(params[:modelo])
    @modelo.user_id = current_user.id
    if @modelo.save
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @modelo = Modelo.find(params[:id])
  end

  def update
    @modelo = Modelo.find(params[:id])
    if @modelo.update_attributes(params[:modelo])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Modelo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def tag_cloud
      @tags = Modelo.tag_counts
  end

  def tag
     redirect_to(:controller => 'temas', :action => 'search', :id => params[:id])
  end

  def csv
    @m = Modelo.find(:all)    
    cabecera = Modelo.column_names.join(";")
    salida = Array.new
    linea = Array.new
    for m in @m
      linea = []
      for columna in Modelo.column_names
        linea << m.send(columna)
      end
      salida << linea
    end
    
    render_csv("modelos_#{Time.now.strftime("%d%m%Y%H%M")}", cabecera, salida)
  end

  def kepler
    @modelo = Modelo.find_by_id(params[:id])
    browser = params[:browser]
    if browser.index("win") != nil
          headers["Content-Type"] = "text/html; charset=ISO-8859-1"
          
          @salida = @modelo.to_kepler(params[:implementacion], "ISO-8859-1")
    else
          headers["Content-Type"] = "text/html; charset=utf-8"
          @salida = @modelo.to_kepler(params[:implementacion], "utf-8")
    end
    headers['Content-Disposition'] = "attachment; filename=\"proto_#{@modelo.label}_#{Time.now.strftime('%d%m%Y%H%M')}.xml\"" 
    render(:xml => @salida)
  end

  def ejecutar
    redirect_to(:controller => 'ejecutar', :action => 'implementaciones', :id => params[:id])
  end

end
