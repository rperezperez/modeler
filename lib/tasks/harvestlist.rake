require 'net/http'
require "rexml/document"

namespace :fuentes_externas do

    task :procesar_eml => :environment do
      
      include REXML
      
      fuentes = Externalsource.all
      for fuente in fuentes
          #Obtenemos el harvestlist de la fuente
          xml =  Net::HTTP.get(URI.parse(fuente.url))
          
          @emls = Array.new
          doc = Document.new xml
          doc.elements.each("harvestList/document/documentURL") { |e|            
            @emls.push(e.text)
          }
          
          #Procesamos cada uno de los eml existentes
          for eml in @emls
            xml =  Net::HTTP.get(URI.parse(eml))            
            doc = Document.new xml            

            packageid = XPath.first(doc, "/eml:eml/@packageId").to_s
            version = packageid.split(".").last
            id_eml = packageid[0..packageid.index(version)-2]
                        
            doc.elements.each("/eml:eml/dataset/dataTable"){ |e|
              entrada = Ientrada.find_by_mdatos(id_eml+";"+XPath.first(e, "entityName").text)
              if entrada == nil              
                entrada = Ientrada.new            
              end
              
              entrada.tipo = XPath.first(e, "entityName").text+" - "+XPath.first(doc, "/eml:eml/dataset/title").text
              atributos = Array.new
              e.elements.each("attributeList/attribute/attributeLabel"){|atri|
                atributos << atri.text
              }
              entrada.descripcion = "Atributos: "+atributos.join(", ")+"."+13.chr+"Descripción de la tabla: "+((XPath.first(e, "entityDescription").text if XPath.first(e, "entityDescription") != nil) || "")+"."+13.chr+"Descripción del paquete de eml: "+XPath.first(doc, "/eml:eml/dataset/abstract/para").text
              entrada.mdatos = id_eml+";"+XPath.first(e, "entityName").text
              entrada.user_id = 0
              entrada.formato = "CSV"
              entrada.disponibilidad = "Descargable desde: "+XPath.first(e, "physical/distribution/online/url").text
              entrada.save
              
              #Creamos la relación entre la entrada y el proceso de colecta
              eml_modelos = ExternalsourceEntrada.find_by_ientrada_id(entrada.id)
              if eml_modelos != nil
                eml_modelos.version = version
                eml_modelos.save
              else                
                eml_modelos = ExternalsourceEntrada.create(:externalsource_id => fuente.id, :ientrada_id => entrada.id, :id_eml => id_eml, :version => version, :datatable => XPath.first(e, "entityName").text)
              end
              
            }            
            
            
            
          end
          
      end
      
#        tipo = "/eml:eml/dataset/title"+"/eml:eml/dataset/dataTable/entityName"
#        descripcion = "/eml:eml/dataset/abstract/para"+"/eml:eml/dataset/project/title"+"/eml:eml/dataset/dataTable/entityName"+"Atributos: "+"/eml:eml/dataset/dataTable/attributeList/attribute/attributeLabel"
#        modelo_datos = "Base de datos"
#        formato = "CSV"
#        disponibilidad = Descargable desde "/eml:eml/dataset/dataTable/physical/distribution/online/url"
        
    end

end
