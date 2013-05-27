require "rexml/document"
include REXML  # so that we don't have to prefix everything with REXML::...

class Ikepler < ActiveRecord::Base
  has_many :ikepleratributos

#  belongs_to :implementacion
  belongs_to :ientrada


  def texto_kepler(texto)
    texto = texto.gsub(/\./, '')
    return texto
  end

  def to_kepler(x,y)
    #Obtenemos del kactor el fuente correspondiente
    @actor = Kactor.find_by_clase(self.clase)

    #generamos el doc XML para trabajar más cómodamente
    doc = Document.new @actor.src

    #sustituimos el nombre de la entidad
    doc.elements["entity"].attributes["name"] = self.nombre.to_s
    doc.elements["entity"].attributes["class"] = self.clase

    #insertamos la documentacion de la ientrada en el actor.
	salida = Array.new
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.ientrada.tipo.to_s+'</configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>[CEAMA] Generador prototipos</configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.ientrada.formato.to_s+'</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.ientrada.descripcion.to_s+'</configure></property>')
	salida.push('</property>');

#insertamos el puerto de salida ficticio que conecta con la entrada de la implementacion

	doc.root[1,0] = REXML::Document.new salida.join(13.chr)

	salida.clear()
      salida.push('        <port name="'+texto_kepler(self.ientrada.tipo.to_s)+'_s_'+self.id.to_s+'" class="ptolemy.actor.TypedIOPort">')
      salida.push('            <property name="output"/>')
      salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
      salida.push('            </property>')
      salida.push('        </port>')
	doc.root[1,0] = REXML::Document.new salida.join(13.chr)

    #insertamos los atributos del actor
    for atributo in self.ikepleratributos
      if atributo.nombre.index("has") == nil or atributo.nombre.index("has") > 0
        if doc.elements["//property[@name='"+atributo.nombre+"']"] != nil
          doc.elements.delete("//property[@name='"+atributo.nombre+"']")
        end
        if doc.elements["//property[@name='port:"+atributo.nombre+"']"] != nil
#           @clase = 'ptolemy.actor.parameters.PortParameter'
           @clase = 'ptolemy.data.expr.Parameter'
         else
           @clase = 'ptolemy.data.expr.Parameter'
        end

        ele = 'property name="'+atributo.nombre+'" class="'+@clase+'" value="'+atributo.valor+'"'
        doc.root[1,0] = Element.new ele
      end
    end

    #eliminamos las referencias a los puertos
  doc.elements.each("//property") { |elemento|
    if elemento.attributes["name"].to_s.index("port:") != nil
          puerto = elemento.attributes["name"].to_s.split("port:")[1].to_s
          doc_puerto = doc.elements["//property[@name='"+puerto+"']"]
          #comprobamos si es obligatorio
          if doc_puerto != nil
          if doc_puerto.elements["//property[@name='_hide']"] or doc_puerto.elements["//property[@name='direction']"].attributes["value"].to_s == 'input'
            doc.elements.delete("//property[@name='"+puerto+"']")
          else
            tipo = doc_puerto.elements["//property[@name='direction']"].attributes["value"].to_s
            ele = "<port name='"+puerto.capitalize+"' class='ptolemy.actor.TypedIOPort'><property name='"+tipo+"'/><property name='_showName' class='ptolemy.kernel.util.Attribute'/></port>"

            doc.elements.delete("//property[@name='"+puerto+"']")
            doc.root[1,0] = REXML::Document.new ele
          end
          end
    end
  }

    ele = '<property name="_location" class="ptolemy.kernel.util.Location" value="{'+x.to_s+', '+y.to_s+'}"></property>'
    doc.root[1,0] = REXML::Document.new ele

    return doc.to_s

  end

end
