class UsersController < ApplicationController
  layout 'indigo'

  before_filter :login_is_admin

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1  	
    @users = User.paginate :page => page, :order => 'updated_at DESC', :per_page => 10
  end

  def show
    @users = User.find(params[:id])
  end


  def edit
    @users = User.find(params[:id])
  end

  def update
    @users = User.find(params[:id])
    if @users.update_attributes(params[:users])
      flash[:notice] = 'Usuario actualizado correctamente'
      redirect_to :action => 'show', :id => @users
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def panel

  end

end
