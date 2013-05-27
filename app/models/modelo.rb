require 'hpricot'
class Modelo < ActiveRecord::Base

file_column :path1
file_column :path2
file_column :path3
file_column :path4 
file_column :mapa_conceptual, :magick => {
          :versions => { "thumb" => "50x50", "medium" => "640x480>" }
        }


  has_and_belongs_to_many :autors, :uniq => true

  has_and_belongs_to_many :bbasicas, :class_name => 'Bibliografia'
  has_and_belongs_to_many :bcomplementarias, :class_name => 'Bibliografia', :join_table => 'bcomplementarias_modelos'

  has_and_belongs_to_many :aagestions
  has_and_belongs_to_many :aaobjetivos
  has_and_belongs_to_many :aambitos
  has_and_belongs_to_many :aaplicacions

  has_and_belongs_to_many :limitacions

  has_and_belongs_to_many :implementacions, :uniq => true

  has_and_belongs_to_many :mnecesarias, :class_name => 'Modificar'
  has_and_belongs_to_many :mrecomendadas, :class_name => 'Modificar'

  validates_uniqueness_of :acronimo, :nombre

  belongs_to :user

  acts_as_taggable


  def mapaconceptual
    mapa_conceptual.split(RAILS_ROOT+"/public")[1] if mapa_conceptual != nil and mapa_conceptual.include?(RAILS_ROOT)
  end

  def label
    self.acronimo
  end

  def autores
    salida = Array.new
    for a in self.autors
      salida.push(a.label)
    end
    return salida.join(";")
  end

  def texto(texto)
    totexto = texto.split(" ")
    a = 0
    tolinea = 90
    linea = 0
    resultado = Array.new
    while a < totexto.size
      resultado.push(totexto[a]+" ")
      linea += totexto[a].length
      if linea >= tolinea
        linea = 0
        resultado.push("&#10;")
      end
      a = a + 1
    end
    return resultado.join("")
  end

  def texto2(texto)
    total = texto.length
    a = 0
    incremento = 60
    resultado = Array.new
    while a < (total+incremento)
      resultado.push(texto[a..a+incremento])
      a = a + incremento
    end
    return resultado.join("&#10;")
  end

  def to_iso(texto)
      obj_iconv = Iconv.new('ISO-8859-1','utf-8')
      text = obj_iconv.iconv(texto)
      return text
  end

  def to_kepler(id_imp, encode)
    implementacion = Implementacion.find_by_id(id_imp)

    salida = Array.new
    salida.push('<?xml version="1.0" encoding="'+encode+'"?>')
    salida.push('<!DOCTYPE entity PUBLIC "-//UC Berkeley//DTD MoML 1//EN"')
    salida.push('    "http://ptolemy.eecs.berkeley.edu/xml/dtd/MoML_1.dtd">')
    salida.push('<entity name="model" class="ptolemy.actor.TypedCompositeActor">')
    salida.push('    <property name="_createdBy" class="ptolemy.kernel.attributes.VersionAttribute" value="7.0.2">')
    salida.push('    </property>')
    salida.push('')

#escribimos la documentacion del modelo
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.resumen.to_s+'</configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.autores.to_s+'</configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+implementacion.version.to_s+'</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>'+self.extendida.to_s+'</configure></property>')
    salida.push('</property>')

#Insertamos el director del modelo
    salida.push('    <property name="SDF Director" class="ptolemy.domains.sdf.kernel.SDFDirector">')
    salida.push('        <property name="iterations" class="ptolemy.data.expr.Parameter" value="0">')
    salida.push('        </property>')
    salida.push('        <property name="vectorizationFactor" class="ptolemy.data.expr.Parameter" value="1">')
    salida.push('        </property>')
    salida.push('        <property name="allowDisconnectedGraphs" class="ptolemy.data.expr.Parameter" value="false">')
    salida.push('        </property>')
    salida.push('        <property name="allowRateChanges" class="ptolemy.data.expr.Parameter" value="false">')
    salida.push('        </property>')
    salida.push('        <property name="constrainBufferSizes" class="ptolemy.data.expr.Parameter" value="true">')
    salida.push('        </property>')
    salida.push('        <property name="period" class="ptolemy.data.expr.Parameter" value="0.0">')
    salida.push('        </property>')
    salida.push('        <property name="synchronizeToRealTime" class="ptolemy.data.expr.Parameter" value="false">')
    salida.push('        </property>')
    salida.push('        <property name="timeResolution" class="ptolemy.moml.SharedParameter" value="1E-10">')
    salida.push('        </property>')
    salida.push('        <property name="Scheduler" class="ptolemy.domains.sdf.kernel.SDFScheduler">')
    salida.push('            <property name="constrainBufferSizes" class="ptolemy.data.expr.Parameter" value="constrainBufferSizes">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('<property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:director:1:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.domains.sdf.kernel.SDFDirector">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:directorclass:1:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType00" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#Director">')
    salida.push('        </property>')
    salida.push('        <property name="semanticType11" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:2:1#Director">')
    salida.push('        </property>')
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="[155.0, 75.0]">')
    salida.push('        </property>')
    salida.push('    </property>')


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
    salida.push('        <property name="text" class="ptolemy.kernel.util.StringAttribute" value="'+self.acronimo.to_s+'">')
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
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="{640, 80}">')
    salida.push('        </property>')
    salida.push('    </property>')

#escribimos la anotación visual de la descripción
    salida.push('    <property name="Annotation" class="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('        <property name="textColor" class="ptolemy.actor.gui.ColorAttribute" value="{0.0,0.4,0.4,1.0}">')
    salida.push('        </property>')
    salida.push('        <property name="text" class="ptolemy.kernel.util.StringAttribute" value="'+self.texto(self.resumen.to_s)+'">')
    salida.push('        </property>')
    salida.push('        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:436:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:1199:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType000" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#DocumentationActor">')
    salida.push('        </property>')
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="[135.0, 665.0]">')
    salida.push('        </property>')
    salida.push('    </property>')

#escribimos el parametro path que sera comun a todos los modelos
    salida.push('      <property name="Path" class="ptolemy.data.expr.Parameter" value="&quot;Obligatorio para ejecutar desde el servidor&quot;">')
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>Este parametro es obligatorio para ejecutar el modelo desde el servidor</configure></property>')
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
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="[340.0, 550.0]">')
    salida.push('        </property>')
    salida.push('    </property>')

    salida.push(implementacion.to_kepler())

    salida.push('</entity>')

    resultado = salida.join(13.chr)
    if encode=='ISO-8859-1'
      resultado = to_iso(resultado)
    end
    return resultado
  end

  def to_kepler2
    salida = Array.new
    salida.push('<?xml version="1.0" encoding="UTF-8"?>')
    salida.push('<!DOCTYPE entity PUBLIC "-//UC Berkeley//DTD MoML 1//EN"')
    salida.push('    "http://ptolemy.eecs.berkeley.edu/xml/dtd/MoML_1.dtd">')
    salida.push('<entity name="model" class="ptolemy.actor.TypedCompositeActor">')
    salida.push('    <property name="_createdBy" class="ptolemy.kernel.attributes.VersionAttribute" value="7.0.2">')
    salida.push('    </property>')
    salida.push('')
    salida.push('<property name="KeplerDocumentation" class="ptolemy.vergil.basic.KeplerDocumentationAttribute">')
    salida.push('<property name="description" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+self.resumen.to_s+']]></configure></property>')
    salida.push('<property name="author" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+self.autores+']]></configure></property>')
    salida.push('<property name="version" class="ptolemy.kernel.util.ConfigurableAttribute"><configure>1.0</configure></property>')
    salida.push('<property name="userLevelDocumentation" class="ptolemy.kernel.util.ConfigurableAttribute"><configure><![CDATA['+self.resumen.to_s+']]></configure></property>')
    salida.push('</property>')

    salida.push('    <property name="Annotation" class="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('        <property name="textColor" class="ptolemy.actor.gui.ColorAttribute" value="{0.0,0.4,0.4,1.0}">')
    salida.push('        </property>')
    salida.push('        <property name="text" class="ptolemy.kernel.util.StringAttribute" value="'+self.texto(Hpricot(self.resumen.to_s).inner_text)+'">')
    salida.push('        </property>')
    salida.push('        <property name="entityId" class="org.kepler.moml.NamedObjId" value="urn:lsid:kepler-project.org:actor:436:1">')
    salida.push('        </property>')
    salida.push('        <property name="class" class="ptolemy.kernel.util.StringAttribute" value="ptolemy.vergil.kernel.attributes.TextAttribute">')
    salida.push('            <property name="id" class="ptolemy.kernel.util.StringAttribute" value="urn:lsid:kepler-project.org:class:1199:1">')
    salida.push('            </property>')
    salida.push('        </property>')
    salida.push('        <property name="semanticType000" class="org.kepler.sms.SemanticType" value="urn:lsid:localhost:onto:1:1#DocumentationActor">')
    salida.push('        </property>')
    salida.push('        <property name="_location" class="ptolemy.kernel.util.Location" value="[110.0, 430.0]">')
    salida.push('        </property>')
    salida.push('    </property>')

    implementacion = self.implementacions.first
    salida.push(implementacion.to_kepler(self.texto(Hpricot(self.resumen.to_s).inner_text)))

    salida.push('</entity>')

    return salida.join(13.chr)
  end


end
