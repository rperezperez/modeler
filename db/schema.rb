# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100917161420) do

  create_table "aagestions", :force => true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aagestions_modelos", :id => false, :force => true do |t|
    t.integer "aagestion_id", :null => false
    t.integer "modelo_id",    :null => false
  end

  create_table "aambitos", :force => true do |t|
    t.string   "descripcion", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aambitos_modelos", :id => false, :force => true do |t|
    t.integer "aambito_id", :null => false
    t.integer "modelo_id",  :null => false
  end

  create_table "aaobjetivos", :force => true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aaobjetivos_modelos", :id => false, :force => true do |t|
    t.integer "aaobjetivo_id", :null => false
    t.integer "modelo_id",     :null => false
  end

  create_table "aaplicacions", :force => true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aaplicacions_modelos", :id => false, :force => true do |t|
    t.integer "aaplicacion_id", :null => false
    t.integer "modelo_id",      :null => false
  end

  create_table "attachments", :force => true do |t|
    t.string   "filename"
    t.integer  "size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
  end

  create_table "autors", :force => true do |t|
    t.string   "nombre",      :null => false
    t.string   "institucion"
    t.string   "direccion"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rol"
  end

  create_table "autors_modelos", :id => false, :force => true do |t|
    t.integer "modelo_id", :null => false
    t.integer "autor_id",  :null => false
  end

  create_table "ayudas", :force => true do |t|
    t.string   "tabla"
    t.string   "campo"
    t.string   "comentario"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bcomplementarias_modelos", :id => false, :force => true do |t|
    t.integer "bibliografia_id", :null => false
    t.integer "modelo_id",       :null => false
  end

  create_table "bibliografias", :force => true do |t|
    t.string   "uri",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descripcion"
  end

  create_table "bibliografias_modelos", :id => false, :force => true do |t|
    t.integer "bibliografia_id", :null => false
    t.integer "modelo_id",       :null => false
  end

  create_table "comentarios", :force => true do |t|
    t.string   "title",      :default => ""
    t.datetime "created_at",                 :null => false
    t.integer  "tema_id",    :default => 0,  :null => false
    t.integer  "user_id",    :default => 0,  :null => false
    t.text     "texto"
  end

  create_table "externalsource_entradas", :force => true do |t|
    t.integer  "externalsource_id"
    t.integer  "ientrada_id"
    t.string   "id_eml"
    t.string   "version"
    t.string   "datatable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "externalsources", :force => true do |t|
    t.string   "nombre"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ientradas", :force => true do |t|
    t.text     "descripcion"
    t.string   "tipo"
    t.string   "formato"
    t.text     "disponibilidad"
    t.string   "path1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mdatos"
    t.integer  "user_id",        :null => false
  end

  create_table "ientradas_implementacions", :id => false, :force => true do |t|
    t.integer "ientrada_id",       :null => false
    t.integer "implementacion_id", :null => false
  end

  create_table "ientradas_modelos", :id => false, :force => true do |t|
    t.integer "ientrada_id", :null => false
    t.integer "modelo_id",   :null => false
  end

  create_table "ikepleratributos", :force => true do |t|
    t.integer  "ikepler_id", :null => false
    t.string   "nombre",     :null => false
    t.string   "clase",      :null => false
    t.string   "valor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ikeplers", :force => true do |t|
    t.string   "nombre",      :null => false
    t.string   "clase",       :null => false
    t.string   "tipo",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "ientrada_id"
  end

  create_table "implementacions", :force => true do |t|
    t.string   "nombre",              :null => false
    t.string   "descarga"
    t.string   "version"
    t.string   "tipo"
    t.string   "c_disponibilidad"
    t.string   "c_descarga"
    t.string   "c_version"
    t.text     "c_lenguaje"
    t.text     "c_bloques"
    t.string   "c_path1"
    t.string   "c_path2"
    t.string   "plataforma"
    t.string   "licencia"
    t.text     "r_software"
    t.text     "r_hardware"
    t.text     "limitaciones"
    t.text     "bugs"
    t.string   "t_ejecucion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",             :null => false
    t.string   "kepler_servidor_xml"
    t.string   "kepler_servidor_tar"
    t.text     "resumen"
    t.string   "kepler_cliente_xml"
    t.string   "acronimo"
  end

  create_table "implementacions_iparametros", :id => false, :force => true do |t|
    t.integer "implementacion_id", :null => false
    t.integer "iparametro_id",     :null => false
  end

  create_table "implementacions_isalidas", :id => false, :force => true do |t|
    t.integer "implementacion_id", :null => false
    t.integer "ientrada_id",       :null => false
  end

  create_table "implementacions_modelos", :id => false, :force => true do |t|
    t.integer "implementacion_id", :null => false
    t.integer "modelo_id",         :null => false
  end

  create_table "iparametros", :force => true do |t|
    t.string   "parametro"
    t.string   "valor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unidad"
    t.text     "descripcion"
  end

  create_table "isalidas", :force => true do |t|
    t.text     "descripcion"
    t.string   "tipo"
    t.string   "formato"
    t.string   "path1"
    t.string   "path2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mdatos"
  end

  create_table "kactorparameters", :force => true do |t|
    t.integer  "kactor_id",     :null => false
    t.string   "nombre",        :null => false
    t.string   "clase",         :null => false
    t.text     "documentacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kactors", :force => true do |t|
    t.string   "nombre",        :null => false
    t.string   "clase",         :null => false
    t.text     "documentacion"
    t.text     "src"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kejecucions", :force => true do |t|
    t.integer  "user_id"
    t.string   "nejecucion"
    t.datetime "limpiado"
    t.string   "idproceso"
    t.datetime "finalizado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "implementacion_id"
    t.text     "comentario"
  end

  create_table "limitacions", :force => true do |t|
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "limitacions_modelos", :id => false, :force => true do |t|
    t.integer "limitacion_id", :null => false
    t.integer "modelo_id",     :null => false
  end

  create_table "modelos", :force => true do |t|
    t.string   "acronimo",          :null => false
    t.string   "nombre",            :null => false
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "palabras_clave",    :null => false
    t.text     "resumen"
    t.text     "extendida",         :null => false
    t.string   "mapa_conceptual"
    t.string   "usabilidad"
    t.text     "utilidad"
    t.text     "implementabilidad"
    t.string   "path1"
    t.string   "path2"
    t.string   "path3"
    t.string   "path4"
    t.integer  "user_id",           :null => false
  end

  create_table "modelos_modificars", :id => false, :force => true do |t|
    t.integer "modelo_id",    :null => false
    t.integer "modificar_id", :null => false
  end

  create_table "modificars", :force => true do |t|
    t.text     "descripcion"
    t.string   "a_nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "temas", :force => true do |t|
    t.string   "titulo"
    t.text     "cuerpo"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.boolean  "is_admin",                                :default => false
    t.string   "api_key",                   :limit => 40, :default => ""
  end

end
