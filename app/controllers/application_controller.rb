# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'fastercsv'

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_metadatos_session_id'
  
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details


  self.allow_forgery_protection = false

    before_filter :set_session

  #  before_filter :login_required

    include AuthenticatedSystem

  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :set_users
    
  def set_users    
      if session[:cas_user] != nil and session[:user_id] == nil      
        sitios = (session[:cas_extra_attributes]["missitios"] if session[:cas_extra_attributes]["missitios"] != nil) || ""
        host = request.env['SERVER_NAME']+request.env['SCRIPT_NAME']
        if sitios.include?(host)
        user = User.find_by_email(session[:cas_user])
        if user == nil
          user = User.create_user(session[:cas_extra_attributes]["login"], session[:cas_user], "cont_mon_"+session[:cas_extra_attributes]["login"])          
        end      
        
        self.current_user = user
        
        else
          render :text => "No tiene permisos para acceder a este sitio ("+host+"). Contacte con el administrador (info@iecolab.es). Sus sitios permitidos: "+sitios.to_s and return true
        end
        
      end
    
  end

  def set_session
    session[:sidebar] = true if session[:sidebar] == nil
  end
  
  def login_is_admin
      if logged_in? and current_user != nil and current_user != 0 and current_user.is_admin?
        return true
      else
        redirect_to(:controller => 'modelos', :action => "index")
      end
  end

  def set_content_type
    @headers["Content-Type"] = "text/html; charset=utf-8"
  end



    def to_encode(texto, from, to)
        obj_iconv = Iconv.new(from,to)
        text = obj_iconv.iconv(texto)
        return text
    end

    def render_csv(filename = nil, cabecera = nil, valores = nil, delimitador = ";")
      filename ||= params[:action]
      filename += '.csv'
      valores ||= params[:valores]
      cabecera ||= params[:cabecera]
      fcsv_options = {
        :row_sep => "\n",
        :col_sep => delimitador,
        :force_quotes => false
      }

      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain" 
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
        headers['Expires'] = "0" 
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
      end

      csv_string = FasterCSV.generate(fcsv_options) do |csv| 
                  csv << cabecera.split(";")
                  valores.each do |e|
  #                  csv << [e.join(";")]
                     csv << e
                  end
                end

      send_data to_encode(csv_string, 'iso-8859-1','utf-8'), :type => "text/plain",:filename=>filename, :disposition => 'attachment'

    end


end
