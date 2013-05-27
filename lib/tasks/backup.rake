namespace :db do
  namespace :backup do
    
    def interesting_tables
      ActiveRecord::Base.connection.tables.sort.reject! do |tbl|
        ['schema_info', 'sessions', 'public_exceptions','schema_migrations'].include?(tbl)
      end
    end
    
    desc "Dump entire db."
    task :write => :environment do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|

        begin
          klass = tbl.classify.constantize
        rescue
          eval "class #{tbl.classify} < ActiveRecord::Base; end"
          klass = tbl.classify.constantize
        end
        
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end
    
    end
    
    task :read => [:environment, 'db:schema:load'] do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|

        begin
          klass = tbl.classify.constantize
        rescue
          eval "class #{tbl.classify} < ActiveRecord::Base; end"
          klass = tbl.classify.constantize
        end

        ActiveRecord::Base.transaction do 
        
          puts "Loading #{tbl}..."
          YAML.load_file("#{tbl}.yml").each do |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
          end

          #Si tiene el campo id, actualizamos el valor de la secuencia
          campos = klass.columns.map{|x| x.name.to_s}
          if campos.include?("id")
            ActiveRecord::Base.connection.execute "SELECT setval('#{tbl}_id_seq',(SELECT max(id) + 1 FROM #{tbl}))"
          end


        end
      end
    
    end
    
  end
end
