class TemasController < ApplicationController
layout 'indigo'

 before_filter :login_is_admin, :only =>[:destroy]


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @temas = Tema.paginate :page => params[:page], :per_page => 10
  end

  def blog
    @temas = Tema.paginate :per_page => 10, :page => params[:page], :order => 'created_at desc'    
  end

  def show
    @tema = Tema.find(params[:id])
  end

  def new
    @tema = Tema.new
  end

  def create
    @tema = Tema.new(params[:tema])
    @tema.user_id = current_user.id
    if @tema.save
      flash[:notice] = 'el Tema añadido correctamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tema = Tema.find(params[:id])
  end

  def update
    @tema = Tema.find(params[:id])
    @tema.user_id = current_user.id
    if @tema.update_attributes(params[:tema])
      flash[:notice] = 'Tema fue actualizado.'
      redirect_to :action => 'show', :id => @tema
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tema.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def insert
    tema = params[:id]
    @tema = Tema.find(tema)
    #@comment = Comentario.new(params[:comment])
    #@comment.user_id = current_user.id
    #@comment.tema_id = @tema.id
    @comment = Comentario.create(:user_id => current_user.id, :tema_id => @tema.id, :title => params[:comment][:title], :texto => params[:comment][:comment])
    if @comment
      flash[:notice] = 'Comentario añadido correctamente.'
      redirect_to :action => 'show', :id => @tema.id
    else
      render :action => 'show'
    end
  end

  def tag_cloud
      @tags = Tema.tag_counts
  end

  def tag
     redirect_to(:controller => 'temas', :action => 'search', :id => params[:id])
  end

  def search
    @search = params[:s] || params[:id]
    @temas_ids = Tema.find_tagged_with(@search, :select => 'title')
    @temas = []
    @temas_ids.each {|x| @temas << Tema.find(x.id)}
    @modelos_ids = Modelo.find_tagged_with(@search)
    @modelos = []
    @modelos_ids.each {|x| @modelos << Modelo.find(x.id)}
  end

end
