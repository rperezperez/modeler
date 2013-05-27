class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Por favor, active su cuenta'
    #@body[:url]  = 
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Su cuenta ha sido activada!'
  end

  def ejecucion_start(user, nombre_modelo, url )
    setup_email(user)
    @subject     += "Inicio: "+nombre_modelo
    @body[:user] = user.login
    @body[:url] = url
    @body[:nombre_modelo] = nombre_modelo
  end

  def ejecucion_end(user, nombre_modelo, url )
    setup_email(user)
    @subject     += "Fin: "+nombre_modelo
    @body[:user] = user.login
    @body[:url] = url
    @body[:nombre_modelo] = nombre_modelo
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    #@recipients = 'ramon.pperez@gmail.com'
    @from        = "noreply@iecolab.es"
    @subject     = "[R_MODELOS] "
    @sent_on     = Time.now
    @body[:user] = user
  end

end
