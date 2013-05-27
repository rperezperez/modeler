class ExternalsourcesController < ApplicationController
  layout 'indigo_ventanas'

  before_filter :login_is_admin

  def index
    list
    render :action => 'list', :layout => 'indigo'    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1  	
    @exsource = Externalsource.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
    render :layout => 'indigo'
  end

  def new
    @exsource = Externalsource.new
  end
  
  def create
    @exsource = Externalsource.new(params[:exsource])
    if @exsource.save
      flash[:notice] = 'OK. Operación concluida con éxito.'
      render :action => 'new'
    else
      render :action => 'new'
    end
    
  end

  def show
    @exsource = Externalsource.find(params[:id])
  end


  def edit
    @exsource = Externalsource.find(params[:id])
  end

  def update
    @exsource = Externalsource.find(params[:id])
    if @exsource.update_attributes(params[:exsource])
      flash[:notice] = 'OK. Operación concluida con éxito.'
      redirect_to :action => 'edit', :id => @exsource
    else
      render :action => 'edit', :id => @exsource
    end
  end

  def destroy
    exsource.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def panel

  end
end
