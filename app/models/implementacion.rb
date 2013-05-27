require 'hpricot'
require 'ftools'
require "rexml/document"

class Implementacion < ActiveRecord::Base
  belongs_to :user

  has_and_belongs_to_many :modelos
  has_and_belongs_to_many :ientradas
  has_and_belongs_to_many :iparametros
  has_and_belongs_to_many :isalidas, :class_name => 'Ientrada', :join_table => 'implementacions_isalidas'
#  has_many :ikeplers
  has_many :kejecucion


  file_column :c_path1
  file_column :c_path2
  file_column :t_ejecucion


  file_column :kepler_servidor_xml
  file_column :kepler_servidor_tar
  file_column :kepler_cliente_xml

  validates_presence_of :nombre

  def label
    self.nombre
  end

  def parametros_ejecucion
    f = File.open(kepler_servidor_xml, "r")

    doc = REXML::Document.new f
    f.close

    #obtenemos los parametros
    @texto = Hash.new
    doc.elements.each("entity/property[@class='ptolemy.data.expr.Parameter']/") { |element| @texto[element.attributes["name"]]= element.attributes["value"] }
    return @texto
  end

  def texto_kepler(texto)
    texto = texto.gsub(/\./, '')
    return texto
  end

def is_numeric?(s)
  return (s.to_s =~ /^\d+(\.\d+|\d*)$/)?true:false
end

  def texto(texto)
    resultado = Array.new
    if texto != nil and texto.length > 0
      totexto = texto.split(" ")
      a = 0
      tolinea = 90
      linea = 0
      while a < totexto.size
        resultado.push(totexto[a]+" ")
        linea += totexto[a].length
        if linea >= tolinea
          linea = 0
          resultado.push("&#10;")
        end
        a = a + 1
      end
     end
    return resultado.join("")
  end

def texto_parametro(nombre, valor, descripcion, x=340.0, y=550.0)
    if not self.is_numeric?(valor)
      valor = "&quot;"+valor+"&quot;"
    end
    salida = Array.new
    salida.push('      <property name="'+self.texto_kepler(nombre)+'" class="ptolemy.data.expr.Parameter" value="'+valor.to_s+'">')
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure></configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>[Ceama] Generador de Prototipos</configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>0.1</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>null</configure></property>')
    salida.push('</property>        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:420:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.data.expr.Parameter">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:1184:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#Parameter">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#Parameter">')
    salida.push('        </property>')
    salida.push('        <property name="_hideName" class="ptolemy.kernel.util.SingletonAttribute">')
    salida.push('        </property>')
    salida.push('        <property name="_icon" class="ptolemy.vergil.icon.ValueIcon">')
    salida.push('            <property name="_color" class="ptolemy.actor.gui.ColorAttribute" value="{0.0, 0.0, 1.0, 1.0}">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="_smallIconDescription" class="ptolemy.kernel.util.SingletonConfigurableAttribute">')
    salida.push('            <configure>')
    salida.push('      <svg>')
    salida.push('        <text x="20" style="font-size:14; font-family:SansSerif; fill:blue" y="20">-P-</text>')
    salida.push('      </svg>')
    salida.push('    </configure>')
    salida.push('        </property>')
    salida.push('        <property name="_editorFactory" class="ptolemy.vergil.toolbox.VisibleParameterEditorFactory">')
    salida.push('        </property>')
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="['+x.to_s+', '+y.to_s+']">')
    salida.push('        </property>')
    salida.push('    </property>')

    salida.push('        <property name="anotacion_p_'+self.texto_kepler(nombre)+'" class="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('            <property name="_hideName" class="ptolemy.data.expr.SingletonParameter" value="true">')
    salida.push('            </property>')
    salida.push('            <property name="_hideAllParameters" class="ptolemy.data.expr.Parameter" value="true">')
    salida.push('            </property>')
    salida.push('            <property name="textSize" class="ptolemy.data.expr.Parameter" value="10">')
    salida.push('            </property>')
    salida.push('            <property name="textColor" class="ptolemy.actor.gui.ColorAttribute" value="{0.0, 0.0, 1.0, 1.0}">')
    salida.push('            </property>')
    salida.push('            <property name="fontFamily" class="ptolemy.data.expr.StringParameter" value="SansSerif">')
    salida.push('            </property>')
    salida.push('            <property name="bold" class="ptolemy.data.expr.Parameter" value="false">')
    salida.push('            </property>')
    salida.push('            <property name="italic" class="ptolemy.data.expr.Parameter" value="false">')
    salida.push('            </property>')
    salida.push('            <property name="text" class="ptolemy.kernel.util.StringAttribute" value="'+self.texto(descripcion)+'">')
    salida.push('                <property name="_style" class="ptolemy.actor.gui.style.TextStyle">')
    salida.push('                    <property name="height" class="ptolemy.data.expr.Parameter" value="20">')
    salida.push('                    </property>')
    salida.push('                    <property name="width" class="ptolemy.data.expr.Parameter" value="80">')
    salida.push('                    </property>')
    salida.push('                </property>')
    salida.push('            </property>')
    salida.push('            <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:436:1">')
    salida.push('            </property>')
    salida.push('            <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('                <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:1199:1">')
    salida.push('                </property>')
    salida.push('            </property>')
    salida.push('            <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#DocumentationActor">')
    salida.push('            </property>')
    salida.push('            <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#WorkflowDocumentation">')
    salida.push('            </property>')
    salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="['+(x+50).to_s+', '+y.to_s+']">')
    salida.push('            </property>')
    salida.push('        </property>')

    return salida
end

  def to_kepler(x=850, y=325)

    salida = Array.new

    salida.push('    <entity name="'+self.texto_kepler(nombre.to_s)+'" class="ptolemy.actor.TypedCompositeActor">')
    salida.push('<display name="'+self.texto_kepler(nombre.to_s)+'"/>        <property name="_createdBy" class="ptolemy.kernel.attributes.VersionAttribute" value="7.0.2">')
    salida.push('        </property>')
    salida.push('        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:449:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.actor.TypedCompositeActor">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:449:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#Actor">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#GeneralPurpose">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType22" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#Workflow">')
    salida.push('        </property>')

        salida.push('<property name="_location" class="ptolemy.kernel.util.Location" value="['+x.to_s+', '+y.to_s+']"></property>')

    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+resumen.to_s+'</configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>[CEAMA] Generador prototipos</configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+version.to_s+'</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+resumen.to_s+'</configure></property>')


    for p in self.ientradas
#        salida.push('<property name="port:'+self.texto_kepler(p.tipo.to_s)+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+p.descripcion.to_s+'</configure></property>')
        salida.push('<property name="port:'+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+p.descripcion.to_s+'</configure></property>')

    end

    for p in self.isalidas
#        salida.push('<property name="port:'+self.texto_kepler(p.tipo.to_s)+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+p.descripcion.to_s+'</configure></property>')
        salida.push('<property name="port:'+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+p.descripcion.to_s+'</configure></property>')
    end

    salida.push('        </property>')
    salida.push('        <property name="" class="ptolemy.vergil.basic.DocAttribute">')
    salida.push('            <property name="author" class="ptolemy.kernel.util.StringAttribute" value="Auto">')
    salida.push('            </property>')
    salida.push('            <property name="version" class="ptolemy.kernel.util.StringAttribute">')
    salida.push('            </property>')
    salida.push('            <property name="since" class="ptolemy.kernel.util.StringAttribute">')
    salida.push('            </property>')
    salida.push('            <property name="description" class="ptolemy.data.expr.StringParameter" value="Nada">')
    salida.push('            </property>')

    for p in self.ientradas
	if p.ikeplers.size.to_i == 0
	      salida.push('            <property name="'+self.texto_kepler(p.tipo.to_s)+' (puerto)" class="ptolemy.kernel.util.StringAttribute" value="'+p.descripcion.to_s+'">')
	      salida.push('            </property>')
	end
    end

    for p in self.isalidas
	if p.ikeplers.size.to_i == 0
	      salida.push('            <property name="'+self.texto_kepler(p.tipo.to_s)+' (puerto)" class="ptolemy.kernel.util.StringAttribute" value="'+p.descripcion.to_s+'>">')
	      salida.push('            </property>')
	end
    end

    salida.push('        </property>')

    #Anotación con el nombre del modelo
    salida.push('    <property name="Annotation2" class="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('        <property name="_hideName" class="ptolemy.data.expr.SingletonParameter" value="true">')
    salida.push('        </property>')
    salida.push('        <property name="_hideAllParameters" class="ptolemy.data.expr.Parameter" value="true">')
    salida.push('        </property>')
    salida.push('        <property name="textSize" class="ptolemy.data.expr.Parameter" value="18">')
    salida.push('        </property>')
    salida.push('        <property name="textColor" class="ptolemy.actor.gui.ColorAttribute" value="{0.0, 0.0, 1.0, 1.0}">')
    salida.push('        </property>')
    salida.push('        <property name="fontFamily" class="ptolemy.data.expr.StringParameter" value="SansSerif">')
    salida.push('        </property>')
    salida.push('        <property name="bold" class="ptolemy.data.expr.Parameter" value="true">')
    salida.push('        </property>')
    salida.push('        <property name="italic" class="ptolemy.data.expr.Parameter" value="true">')
    salida.push('        </property>')
    salida.push('        <property name="text" class="ptolemy.kernel.util.StringAttribute" value="Actor: '+self.nombre.to_s+'">')
    salida.push('            <property name="_style" class="ptolemy.actor.gui.style.TextStyle">')
    salida.push('                <property name="height" class="ptolemy.data.expr.Parameter" value="20">')
    salida.push('                </property>')
    salida.push('                <property name="width" class="ptolemy.data.expr.Parameter" value="80">')
    salida.push('                </property>')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:436:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:1199:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#DocumentationActor">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#WorkflowDocumentation">')
    salida.push('        </property>')
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="{85.0, 20.0}">')
    salida.push('        </property>')
    salida.push('    </property>')



    x_parametro = 380
    y_parametro = 100
    for p in self.iparametros
      salida.push(texto_parametro(p.parametro.to_s, p.valor, p.descripcion, x_parametro, y_parametro).join(13.chr))
      y_parametro += 60
    end

#    x_ikepler = 400
#    y_ikepler = 100
#    for p in self.ikeplers
#      salida.push(p.to_kepler(x_ikepler, y_ikepler))
#      y_ikepler += 60
#    end


    x_entrada = 100
    y_entrada = 100
    for p in self.ientradas
#      salida.push('        <port name="'+self.texto_kepler(p.tipo.to_s)+'" class="ptolemy.actor.TypedIOPort">')
      salida.push('        <port name="'+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.actor.TypedIOPort">')
      salida.push('            <property name="input"/>')
      salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
      salida.push('            </property>')
      salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="{'+x_entrada.to_s+', '+y_entrada.to_s+'}">')
      salida.push('            </property>')
      salida.push('        </port>')
      y_entrada += 50
    end

    x_salida = 680.0
    y_salida = 100
    for p in self.isalidas
#      salida.push('        <port name="'+self.texto_kepler(p.tipo.to_s)+'" class="ptolemy.actor.TypedIOPort">')
      salida.push('        <port name="'+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.actor.TypedIOPort">')
      salida.push('            <property name="output"/>')
      salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
      salida.push('            </property>')
      salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="{'+x_salida.to_s+', '+y_salida.to_s+'}">')
      salida.push('            </property>')
      salida.push('        </port>')
      y_salida += 50
    end


	for p in self.isalidas
		if p.ikeplers.size > 0
	
			salida.push('    <relation name="ientrada_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.actor.TypedIORelation">')
			salida.push('	 <property name="width" class="ptolemy.data.expr.Parameter" value="1">')
			salida.push('        </property>')
			salida.push('        <vertex name="vertex1" value="['+(x-150).to_s+','+(y-y*0.20*p.ikeplers.size.to_i).to_s+']">')
			salida.push('        </vertex>')
			salida.push('    </relation>')
			for k in p.ikeplers
				salida.push(k.to_kepler(x-200, y-y*0.20*p.ikeplers.size))
				salida.push('    <link port="'+k.nombre.to_s+'.'+texto_kepler(p.tipo.to_s)+'_s_'+k.id.to_s+'" relation="ientrada_'+self.id.to_s+'_'+p.id.to_s+'"/>')
			end
#			salida.push('    <link port="'+self.texto_kepler(nombre.to_s)+"."+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" relation="ientrada_'+self.id.to_s+'_'+p.id.to_s+'"/>')
			x = x -150
			y = y -y*0.20*p.ikeplers.size.to_i

		end

	end


    salida.push('    </entity>')

    #construimos la relacion entre los actores ikepler de las entradas/salidas con la implementación
	for p in self.ientradas
#		if p.ikeplers.size > 0

		salida.push('    <relation name="ientrada_'+self.id.to_s+'_'+p.id.to_s+'" class="ptolemy.actor.TypedIORelation">')
		salida.push('	 <property name="width" class="ptolemy.data.expr.Parameter" value="1">')
		salida.push('        </property>')
		salida.push('        <vertex name="vertex1" value="['+(x-150).to_s+','+(y-y*0.20*p.ikeplers.size.to_i).to_s+']">')
		salida.push('        </vertex>')
		salida.push('    </relation>')
		for k in p.ikeplers
			salida.push(k.to_kepler(x-200, y-y*0.20*p.ikeplers.size))
			salida.push('    <link port="'+k.nombre.to_s+'.'+texto_kepler(p.tipo.to_s)+'_s_'+k.id.to_s+'" relation="ientrada_'+self.id.to_s+'_'+p.id.to_s+'"/>')
		end
		salida.push('    <link port="'+self.texto_kepler(nombre.to_s)+"."+texto_kepler(p.tipo.to_s)+'_'+self.id.to_s+'_'+p.id.to_s+'" relation="ientrada_'+self.id.to_s+'_'+p.id.to_s+'"/>')
		#x = x -150
		y = y -y*0.20*p.ikeplers.size.to_i-100

#		end
	end



    #si tengo alguna entrada que depende de otra implementación voy a incluir el actor correspondiente

    implementacions = Implementacion.find_by_sql ["select i.implementacion_id, i.ientrada_id from ientradas_implementacions e, implementacions_isalidas i where e.implementacion_id=? and e.ientrada_id=i.ientrada_id and i.implementacion_id != ?", self.id, self.id]
    for i in implementacions
      imp = Implementacion.find(i.implementacion_id)
      salida.push(imp.to_kepler(x-200, y-y*0.20*implementacions.size))

#      salida.push('    <relation name="relation'+id.to_s+"_"+i.ientrada_id.to_s+'" class="ptolemy.actor.TypedIORelation">')
#      salida.push('        <property name="width" class="ptolemy.data.expr.Parameter" value="1">')
#      salida.push('        </property>')
#      salida.push('    </relation>')

#      salida.push('    <link port="'+self.texto_kepler(nombre.to_s)+"."+texto_kepler(self.ientradas.find_by_id(i.ientrada_id).tipo.to_s)+'_'+self.id.to_s+'_'+i.ientrada_id.to_s+'" relation="ientrada_'+id.to_s+"_"+i.ientrada_id.to_s+'"/>')
      salida.push('    <link port="'+self.texto_kepler(imp.nombre.to_s)+"."+texto_kepler(self.ientradas.find_by_id(i.ientrada_id).tipo.to_s)+'_'+imp.id.to_s+'_'+i.ientrada_id.to_s+'" relation="ientrada_'+id.to_s+"_"+i.ientrada_id.to_s+'"/>')

    end

    

    return salida.join(13.chr)

  end

# def before_save
#        self.user_id = current_user.id
#  end


  def to_kepler2(resumen)

    salida = Array.new

    salida.push('    <entity name="'+nombre.to_s+'" class="ptolemy.actor.TypedCompositeActor">')
    salida.push('<display name="'+nombre.to_s+'"/>        <property name="_createdBy" class="ptolemy.kernel.attributes.VersionAttribute" value="7.0.2">')
    salida.push('        </property>')
    salida.push('        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:449:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.actor.TypedCompositeActor">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:449:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#Actor">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#GeneralPurpose">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType22" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#Workflow">')
    salida.push('        </property>')
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+resumen.to_s+']]></configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>Metadatos - Ceama</configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>0.1</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+resumen.to_s+']]></configure></property>')

    for p in self.ientradas
        salida.push('<property name="port:'+p.tipo.to_s+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+p.descripcion.to_s+']]></configure></property>')
    end

    for p in self.iparametros
        salida.push('<property name="port:P_'+p.parametro.to_s+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+p.parametro.to_s+': '+p.valor.to_s+']]></configure></property>')
    end

    for p in self.isalidas
        salida.push('<property name="port:'+p.tipo.to_s+'" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+p.descripcion.to_s+']]></configure></property>')
    end

    salida.push('        </property>')
    salida.push('        <property name="" class="ptolemy.vergil.basic.DocAttribute">')
    salida.push('            <property name="author" class="ptolemy.kernel.util.StringAttribute" value="Auto">')
    salida.push('            </property>')
    salida.push('            <property name="version" class="ptolemy.kernel.util.StringAttribute">')
    salida.push('            </property>')
    salida.push('            <property name="since" class="ptolemy.kernel.util.StringAttribute">')
    salida.push('            </property>')
    salida.push('            <property name="description" class="ptolemy.data.expr.StringParameter" value="Nada">')
    salida.push('            </property>')

    for p in self.ientradas
      salida.push('            <property name="'+p.tipo.to_s+' (puerto)" class="ptolemy.kernel.util.StringAttribute" value="'+Hpricot(p.descripcion.to_s).inner_text+'">')
      salida.push('            </property>')
    end

    for p in self.iparametros
      salida.push('            <property name="P_'+p.parametro.to_s+' (puerto)" class="ptolemy.kernel.util.StringAttribute" value="'+Hpricot(p.valor.to_s).inner_text+'">')
      salida.push('            </property>')
    end

    for p in self.isalidas
      salida.push('            <property name="'+p.tipo.to_s+' (puerto)" class="ptolemy.kernel.util.StringAttribute" value="'+Hpricot(p.descripcion.to_s).inner_text+'>">')
      salida.push('            </property>')
    end

    salida.push('        </property>')

    for p in self.ientradas
    salida.push('        <port name="'+p.tipo.to_s+'" class="ptolemy.actor.TypedIOPort">')
    salida.push('            <property name="input"/>')
    salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
    salida.push('            </property>')
    salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="{0.0, 0.0}">')
    salida.push('            </property>')
    salida.push('        </port>')
    end

    for p in self.iparametros
    salida.push('        <port name="P_'+p.parametro.to_s+'" class="ptolemy.actor.TypedIOPort">')
    salida.push('            <property name="input"/>')
    salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
    salida.push('            </property>')
    salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="{0.0, 0.0}">')
    salida.push('            </property>')
    salida.push('        </port>')
    end

    for p in self.isalidas
    salida.push('        <port name="'+p.tipo.to_s+'" class="ptolemy.actor.TypedIOPort">')
    salida.push('            <property name="output"/>')
    salida.push('            <property name="_showName" class="ptolemy.data.expr.SingletonParameter" value="true">')
    salida.push('            </property>')
    salida.push('            <property name="_location" class="ptolemy.kernel.util.Location" value="{0.0, 0.0}">')
    salida.push('            </property>')
    salida.push('        </port>')
    end
    salida.push('    </entity>')

    #si tengo alguna entrada que depende de otra implementación voy a incluir el actor correspondiente

    implementacions = Implementacion.find_by_sql ["select i.implementacion_id, i.ientrada_id from ientradas_implementacions e, implementacions_isalidas i where e.implementacion_id=? and e.ientrada_id=i.ientrada_id and i.implementacion_id != ?", self.id, self.id]
    for i in implementacions
      imp = Implementacion.find(i.implementacion_id)
      salida.push(imp.to_kepler(resumen))

      salida.push('    <relation name="relation'+id.to_s+"_"+i.ientrada_id.to_s+'" class="ptolemy.actor.TypedIORelation">')
      salida.push('        <property name="width" class="ptolemy.data.expr.Parameter" value="1">')
      salida.push('        </property>')
      salida.push('    </relation>')

      salida.push('    <link port="'+nombre.to_s+"."+self.ientradas.find_by_id(i.ientrada_id).tipo.to_s+'" relation="relation'+id.to_s+"_"+i.ientrada_id.to_s+'"/>')
      salida.push('    <link port="'+imp.nombre.to_s+"."+self.ientradas.find_by_id(i.ientrada_id).tipo.to_s+'" relation="relation'+id.to_s+"_"+i.ientrada_id.to_s+'"/>')

    end

    return salida.join(13.chr)

  end


end
