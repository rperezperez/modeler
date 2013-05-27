require 'iconv'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper



include TagsHelper

  # The ruby version of the CSS Browser Selector with some additions
      def determine_browser_and_os(ua = request.env["HTTP_USER_AGENT"])
        ua = (ua||"").downcase
        br = (!(/opera|webtv/i=~ua)&&/msie (\d)/=~ua) ?
             'ie ie'+Regexp.last_match(1) :                  # ie
             ua.include?('firefox/2') ? 'gecko ff2' :        # ff2 explicitly
             ua.include?('firefox/3') ? 'gecko ff3' :        # ff3 explicitly
             ua.include?('gecko/') ? 'gecko' :               # ns
             ua.include?('opera/9') ? 'opera opera9' :       # opera 9 only
             /opera (\d)/=~ua || /opera\/(\d)/=~ua ?
             'opera opera'+Regexp.last_match(1) :            # opera
             ua.include?('konqueror') ? 'konqueror' :        # konqueror
             /applewebkit\/(\d+)/=~ua ?
             (build = Regexp.last_match(1).to_i) &&
             'webkit safari safari' +                        # safari
                (/version\/(\d+)/=~ua ?
                Regexp.last_match(1) :
                (build >= 400) ? '2' : '1') :                 # safari version
             ua.include?('mozilla/') ? 'gecko' : nil          # ff
        os = ua.include?('mac') || ua.include?('darwin') ? ua.include?('iphone') ? 'iphone mac' : ua.include?('ipod') ? 'ipod mac' : 'mac' :
             ua.include?('x11') || ua.include?('linux') ? 'linux' :
             ua.include?('win') ? 'win' : nil
        "#{br}#{" " unless br.nil? or os.nil?}#{os}"
      end


def end_form_tag
 "</form>"
end

def start_form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
 form_tag(url_for_options, options, parameters_for_url, block)
end 

def start_form_tag(url_for_options = {})
 form_tag(url_for_options)
end 

def form_remote_tag(options = {}, &block)
  options[:form] = true
  options[:html] ||= {}
  options[:html][:onsubmit] = (options[:html][:onsubmit] ? options[:html][:onsubmit] + "; " : "") + "#{remote_function(options)}; return false;"

  form_tag(options[:html].delete(:action) || url_for(options[:url]), options[:html], &block)
end

  def file_column_field_ayuda(object, field, nombre_objecto, options={})
    cadena = ''
    valor =
    if object.send(field) != nil
      valor = object.send(field)
      if (valor.include? "jpg" or valor.include? "png" or valor.include? "gif" or valor.include? "JPG")
        cadena = link_to image_tag(url_for_file_column(object, field), :size => "100x100"), url_for(:controller => "/", :only_path => true)+url_for_file_column(object, field).to_s
      else
        #cadena = link_to "Descargar", url_for(:controller => "/", :only_path => true)+url_for_file_column(object, field).to_s
        cadena = link_to("Descargar", url_for_file_column(object, field, :absolute => true))
      end
   end
   cadena += "<br/>"+file_column_field(nombre_objecto, field, options)
   return cadena
  end


  def fckeditor_text_area(object, method, value, options = {})
   javascript_tag( "FCKeditorAPI = null; " ) + "\n" +
   javascript_tag( "__FCKeditorNS = null; " ) + "\n" +
   "<textarea id=\"" + object + "_" + method + "\" name=\"" + object + "[" + method + "]\">" + value + "</textarea>" +
   javascript_tag( "var oFCKeditor = new FCKeditor('" + object + "[" + method + "]',700,400,'Basic');oFCKeditor.ReplaceTextarea()" )
  end

  def fckeditor_text_areaMini(object, method, value, options = {})
   javascript_tag( "FCKeditorAPI = null; " ) + "\n" +
   javascript_tag( "__FCKeditorNS = null; " ) + "\n" +
   "<textarea id=\"" + object + "_" + method + "\" name=\"" + object + "[" + method + "]\">" + value + "</textarea>" +
   javascript_tag( "var oFCKeditor = new FCKeditor('" + object + "[" + method + "]',600,300,'Basic');oFCKeditor.ReplaceTextarea()" )
  end

  def ayuda(tabla, campo)
    return "<div class='ayuda' id='ayuda_"+tabla+"_"+campo+"' style='display: none;'>"+ Ayuda.texto(tabla,campo)+"</div>"
  end

  def text_area_ayuda(object, name, options={})
    options["onFocus"] = '$("ayuda_'+object+'_'+name+'").appear();';
    options["onBlur"] = '$("ayuda_'+object+'_'+name+'").fade();';
    options["rows"] = 15
    options["cols"] = 100

    return ayuda(object, name) + text_area(object, name, options)
  end

  def text_field_ayuda(object, name, options={})
    options["size"] = 100
    options["onFocus"] = '$("ayuda_'+object+'_'+name+'").appear();';
    options["onBlur"] = '$("ayuda_'+object+'_'+name+'").fade();';

    return ayuda(object, name) + text_field(object, name, options)
  end

  def file_field_ayuda(object, name, options={})
    options["onFocus"] = '$("ayuda_'+object+'_'+name+'").appear();';
    options["onBlur"] = '$("ayuda_'+object+'_'+name+'").fade();';    
    
    
    http = link_to "Descargar", url_for(:controller => "/", :only_path => true)+url_for_file_column(object, name).to_s
    return ayuda(object, name)+file_field(object, name, options)+http
#    instance_variable_get("@#{object}").send(name).to_s+"--"
  end

end
