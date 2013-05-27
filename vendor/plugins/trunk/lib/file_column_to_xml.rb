module ActiveRecord #:nodoc:

    class XmlSerializer #:nodoc:

      class Attribute #:nodoc:      
              def compute_value
                if @record.methods.include?(name+"_relative_path")
                  http = "http://"+(ActionMailer::Base.default_url_options[:host] || "localhost")+":"+(ActionMailer::Base.default_url_options[:port].to_s || "80")+"/"
                  value = (http+@record.send(name+"_options")[:base_url]+"/"+@record.send(name+"_relative_path")) if @record.send(name+"_relative_path") != nil
                else
                  value = @record.send(name)
                end

                if formatter = Hash::XML_FORMATTING[type.to_s]
                  value ? formatter.call(value) : nil
                else
                  value
                end
              end
      end

    end
    
end
