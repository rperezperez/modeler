class AyudasController < ApplicationController
  layout 'indigo'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1  	
    @ayudas = Ayuda.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
    
    render :layout => 'indigo'
  end

  def show
    @ayuda = Ayuda.find(params[:id])
  end

  def new
    @ayuda = Ayuda.new
  end

  def create
    @ayuda = Ayuda.new(params[:ayuda])
    if @ayuda.save
      flash[:notice] = 'Ayuda was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @ayuda = Ayuda.find(params[:id])
  end

  def update
    @ayuda = Ayuda.find(params[:id])
    if @ayuda.update_attributes(params[:ayuda])
      flash[:notice] = 'Ayuda was successfully updated.'
      redirect_to :action => 'show', :id => @ayuda
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ayuda.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
