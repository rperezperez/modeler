class AccountController < ApplicationController
  layout 'indigo', :except => 'change_password'

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

#  observer :user_observer

  # If you want "remember me" functionality, add this before_filter to Application Controller
#  before_filter :login_from_cookie
# before_filter :login_required, :except => [:login, :signup, :activate]

  def cambiar_sidebar
    sidebar = params[:sidebar] || 'true'
    session[:sidebar] = (sidebar == 'true')
    render :layout => false
  end

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    redirect_to(:controller => 'modelos')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/modelos', :action => 'index')
      flash[:notice] = "Login correcto!!"
    else
      flash[:notice] = "Indentificaci&oacute;n incorrecta!!"
    end
  end

 def change_password
    render(:layout => 'indigo') unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        if current_user.save
          flash[:notice] = "Password actualizado"
          redirect_to :controller => 'modelos'
        else
          flash[:notice] = "Password no actualizado"
        end
       else
        flash[:notice] = "Password no introducido"
        @old_password = params[:old_password]
      end
    else
      flash[:notice] = "Password incorrecto"
    end
  end



  def signup
    @user = User.new(params[:user])
    return unless request.post?
    if @user.save
      #self.current_user = @user
      redirect_back_or_default(:controller => '/account', :action => 'login')
      flash[:notice] = "Gracias por registrarse! Active su cuenta desde el correo electrónico"
    else
      flash[:notice] = "No se ha realizado el registro correctamente."
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Ha salido del sistema."
    
    CASClient::Frameworks::Rails::Filter.logout(self)    
    
    #redirect_back_or_default(:controller => '/account', :action => 'index')
  end

 def activate
    if params[:activation_code]
      @user = User.find_by_activation_code(params[:activation_code])
      if @user and @user.activate
        self.current_user = @user
        @user.activated_at = Time.now
        @user.activation_code = nil
        logger.info "Activando el usuario"
        @user.save
        
        redirect_back_or_default(:controller => '/account', :action => 'index')
        flash[:notice] = "Su cuenta ha sido activada."
      else
        flash[:error] = "No se puede activar su cuenta. La información proporcionada es correcta?"
      end
    else
      flash.clear
    end
  end

end
