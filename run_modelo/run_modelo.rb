require 'config/environment.rb'

### Usuario Kepler del SO para ejecutar los modelos
user_kepler = 'kepler'
password_kepler = 'mA_MqaK3'

### Configuración de Kepler
path_kepler = '/apps/compartido/utils/kepler_2.2/kepler.sh'

def mensaje(path, msg)
  puts msg
  File.open(path+'/log_rmodelo.txt', 'a') do |f2|  
     f2.puts I18n.l(Time.now, :format => :short)+" - "+ msg  
  end
end

def texto(path)
  text = ''
  File.open(path+'/log_rmodelo.txt', 'r') do |f2|  
     while line = f2.gets  
      text += line+'\n'
     end
  end
  return text
end

#Leemos los argumentos
if ARGV.length != 3
  puts "Necesita 3 parámetros: path, id de la implementación, id de la ejecución"
  exit
end

path = ARGV[0]
id = ARGV[1]
ejecucion_id = ARGV[2]

ejecucion = Kejecucion.find_by_id(ejecucion_id)

mensaje(path, "Iniciando los procesos necesarios para la ejecución ...")
implementacion = Implementacion.find_by_id(id)

mensaje(path, "Descomprimiendo archivos necesarios ... #{implementacion.kepler_servidor_tar}")
system("tar xof #{implementacion.kepler_servidor_tar} -C #{path}")

system("chown -R #{user_kepler}:www-data #{path}")
#system("chmod -R 777 #{path}")

mensaje(path, "Ejecutando el modelo ...")

## ver sudoers para habilitar un usuario a ejecutar procesos de otro.

system("echo #{password_kepler} | sudo -S -u #{user_kepler} #{path_kepler} -runwf -nogui #{path}/flujo_kepler.xml 2>> #{path}/log_rmodelo.txt")

salida_fichero = %x[cat #{path}/log.txt]

mensaje(path, salida_fichero)

mensaje(path, "Creando comprimido de resultados ... ")

system("zip -j -D #{path}/../../../public/run_modelo/resultados_#{ejecucion.idproceso}.zip #{path}/resultados/*")

mensaje(path, "Enviando email de finalizacion ... ")
UserNotifier.deliver_ejecucion_end(ejecucion.user, ejecucion.implementacion.nombre, "resultados_#{ejecucion.idproceso}.zip")

mensaje(path, "Proceso Finalizado")
ejecucion.finalizado = Time.now()
ejecucion.comentario = texto(path)
ejecucion.save

system("rm -r #{path}")